{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      up = ''
        	if not set -q argv[1]
        		set argv[1] 1
        	end
        	cd (printf "%.s../" (seq $argv[1]));
        	ls
      '';
      cdl = ''
        	cd $argv[1]
        	ls
      '';
      lst = ''
        	# add --no-user
        	${pkgs.exa}/bin/exa -Tl --git --no-permissions --git-ignore --icons -I=".git" $argv
      '';
      mkcd = ''
        	mkdir $argv[1]
        	cd $argv[1]
      '';
    };

    shellInit = ''
      fish_vi_key_bindings
      set -U fish_greeting ""
    '';

    # loginShellInit = ''
    #   if status is-login
    #       if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    #           exec Hyprland
    #       end
    #   end
    # '';
  };
}