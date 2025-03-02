{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      nish = "nix-shell --run fish -p";
      bnix = "sudo nixos-rebuild boot --flake .#laptop";
      tnix = "sudo nixos-rebuild test --flake .#laptop";
      snix = "sudo nixos-rebuild switch --flake .#laptop";
      chrome = "google-chrome-stable";
      tabname = "wezterm cli set-tab-title";
    };
    functions = {
      # `cd ..` multiple times
      up = ''
        if not set -q argv[1]
        	set argv[1] 1
        end
        cd (printf "%.s../" (seq $argv[1]));
        ls
      '';
      # `eza` with tree-like output
      lst = let
        base = "${pkgs.eza}/bin/eza -Tl --git --no-permissions --git-ignore --icons";
      in ''
        # Check if last argument is number (for -L argument)
        # https://stackoverflow.com/a/56615368/17903686
        math "0+$argv[-1]" 2&>/dev/null
        if test $status -ne 0
          ${base} $argv
        else
          ${base} $argv[1..-2] -L $argv[-1]
        end
      '';
      # `mkdir` + `cd`
      mkcd = ''
        mkdir $argv[1]
        cd $argv[1]
      '';
      # https://fishshell.com/docs/current/interactive.html#programmable-title
      fish_title = ''
        if test -z $argv[1]
          prompt_pwd
        else
          echo $argv[1]
        end
      '';
      # Remove `Ctrl-d` bindings to avoid accidentally closing a shell when the pager is not present
      fish_user_key_bindings = ''
        bind --erase --mode insert --preset \cd
        bind --erase --mode visual --preset \cd
        bind --erase --preset \cd
      '';
    };

    shellInit = ''
      # fish_vi_key_bindings
      set -U fish_greeting ""

      # Disable noise from direnv
      set -x DIRENV_LOG_FORMAT ""
    '';

    interactiveShellInit = ''
      # Current directory as fallback (run local scripts without ./)
      # set PATH $PATH .
    '';
  };
}
