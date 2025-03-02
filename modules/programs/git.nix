{...}: {
  programs.git = {
    enable = true;
    userName = "woojiq";
    userEmail = "yurii.shymon@gmail.com";
    aliases = {
      "s" = "status";
      "d" = "diff";
      "ds" = "diff --stat";
      lg = "log --graph --all --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      logp = "log --format='%h %as | %s [%an]'";
      # Amend to a specific commit and autosquash.
      # https://stackoverflow.com/questions/3321492/git-alias-with-positional-parameters
      # Normally we would do `rebase X~1`, but we also need to count the new commit created by `commit --fixup`.
      comend = "!f() { git commit --fixup=amend:\"$1\" && git rebase \"$1~2\" --autosquash; }; f";
    };
    # TODO: Script that shows branch name and last commit date
    extraConfig = {
      branch.sort = "-committerdate";
      core.fsmonitor = true;
      credential.helper = "store";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      pull.rebase = true;
      rerere.enabled = true;
      rebase.updateRefs = true;
    };
    delta.enable = true;
  };
}
