{...}: {
  programs.git = {
    enable = true;
    userName = "woojiq";
    userEmail = "yurii.shymon@gmail.com";
    aliases = {
      lg = "log --graph --all --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
    };
    # TODO: Script that shows branch name and last commit date
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      pull.rebase = true;
      rerere.enabled = true;
      branch.sort = "-committerdate";
      core.fsmonitor = true;
    };
    delta.enable = true;
  };
}
