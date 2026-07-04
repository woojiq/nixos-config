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
      # set -x DIRENV_LOG_FORMAT ""
    '';

    interactiveShellInit = ''
      # Current directory as fallback (run local scripts without ./)
      # set PATH $PATH .

      # default-rgb is close but not the same
      # from ~/.config/fish/conf.d/fish_frozen_theme.fish.bak (without --global)
      set fish_color_autosuggestion 555 brblack
      set fish_color_cancel -r
      set fish_color_command blue
      set fish_color_comment red
      set fish_color_cwd green
      set fish_color_cwd_root red
      set fish_color_end green
      set fish_color_error brred
      set fish_color_escape brcyan
      set fish_color_history_current --bold
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_normal normal
      set fish_color_operator brcyan
      set fish_color_param cyan
      set fish_color_quote yellow
      set fish_color_redirection cyan --bold
      set fish_color_search_match white --background=brblack
      set fish_color_selection white --bold --background=brblack
      set fish_color_status red
      set fish_color_user brgreen
      set fish_color_valid_path --underline
      set fish_pager_color_completion normal
      set fish_pager_color_description B3A06D yellow -i
      set fish_pager_color_prefix normal --bold --underline
      set fish_pager_color_progress brwhite --background=cyan
      set fish_pager_color_selected_background -r
    '';
  };
}
