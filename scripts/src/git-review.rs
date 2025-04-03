// Inspired by https://github.com/matklad/config/blob/be79c3ef7d15cd1d78c9a0163a33af7af25799c5/tools/gg/src/main.rs#L297-L309
#![allow(clippy::single_component_path_imports)]

use anyhow;
use xflags;
use xshell;

xflags::xflags! {
    cmd git-review {
        /// Start review PR
        cmd start {
            required pr_id: u32
            optional dst_branch: String
        }
        /// End review PR
        cmd end {
        }
        /// Open PR modified files in EDITOR
        cmd open {
        }
    }
}

type Result<T = ()> = anyhow::Result<T>;

fn main() -> Result {
    let cli = GitReview::from_env_or_exit();

    match cli.subcommand {
        GitReviewCmd::Start(Start { pr_id, dst_branch }) => start(pr_id, dst_branch)?,
        GitReviewCmd::End(_) => end()?,
        GitReviewCmd::Open(_) => open()?,
    }

    Ok(())
}

pub fn start(pr_id: u32, dst_branch: Option<String>) -> Result {
    let sh = xshell::Shell::new()?;

    let remote = {
        let remotes = cmd!(sh, "git remote").read()?;
        if remotes.contains("upstream") {
            "upstream".to_string()
        } else {
            "origin".to_string()
        }
    };

    let default_branch = {
        let remote = cmd!(sh, "git remote show {remote}").read()?;
        let head = cmd!(sh, "grep 'HEAD branch'").stdin(&remote).read()?;
        cmd!(sh, "sed 's/.*: //'").stdin(&head).read()?
    };

    let dst_branch = dst_branch.unwrap_or(default_branch.clone());

    let pr_id = pr_id.to_string();

    let fetch_url = {
        let remote = cmd!(sh, "git remote show {remote}").read()?;
        let fetch = cmd!(sh, "grep 'Fetch URL'").stdin(&remote).read()?;
        cmd!(sh, "sed 's/.*: //'").stdin(&fetch).read()?
    };

    cmd!(sh, "git fetch {remote} {dst_branch}").run()?;

    if fetch_url.contains("github") {
        cmd!(sh, "git fetch {remote} pull/{pr_id}/head").run()?
    } else if fetch_url.contains("gitlab") {
        cmd!(sh, "git fetch {remote} merge-requests/{pr_id}/head").run()?
    } else {
        anyhow::bail!("Unknown git service {fetch_url}.");
    }

    cmd!(sh, "git switch --detach FETCH_HEAD").run()?;

    let base = cmd!(sh, "git merge-base FETCH_HEAD {remote}/{dst_branch}").read()?;
    cmd!(sh, "git reset {base}").run()?;

    // This helps get rid of untracked files after switching to the previous branch.
    cmd!(sh, "git add --all --intent-to-add").run()?;

    Ok(())
}

pub fn end() -> Result {
    let sh = xshell::Shell::new()?;

    if cmd!(sh, "git symbolic-ref -q HEAD").run().is_ok() {
        println!("Git repo is not in Detached state.");
        return Ok(());
    }

    cmd!(sh, "git reset --hard").run()?;
    cmd!(sh, "git switch -").run()?;

    Ok(())
}

pub fn open() -> Result {
    let sh = xshell::Shell::new()?;

    let status_raw = cmd!(sh, "git status --porcelain").read()?;

    let modified = status_raw
        .lines()
        .filter_map(|s| {
            let (p1, p2) = s.trim().split_once(' ')?;
            // No need to open deleted files.
            if p1 == "D" {
                None
            } else {
                Some(p2.trim().to_string())
            }
        })
        // Open all files in new directories.
        .map(|s| if s.ends_with('/') { s + "**" } else { s })
        .collect::<Vec<_>>();

    if modified.is_empty() {
        println!("No files has been modified.");
        return Ok(());
    }

    let editor = sh.var("EDITOR")?;

    cmd!(sh, "{editor} {modified...}")
        .to_command()
        .spawn()?
        .wait()?;

    Ok(())
}

#[macro_export]
macro_rules! cmd {
    ($sh:expr, $cmd:literal) => {{
        let cmd = ::xshell::cmd!($sh, $cmd);
        eprintln!("$ {cmd}");
        cmd
    }};
}
