{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      # `cd ..` multiple times
      up = ''
        	if not set -q argv[1]
        		set argv[1] 1
        	end
        	cd (printf "%.s../" (seq $argv[1]));
        	ls
      '';
      # `exa` with tree-like output
      lst =
        let
          base = "${pkgs.exa}/bin/exa -Tl --git --no-permissions --git-ignore --icons -I=\".git\"";
        in
        ''
          # Check if last argument is number (for -L argument)
          # https://stackoverflow.com/a/56615368/17903686
          math "0+$argv[-1]" 2>/dev/null
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
      fish_user_key_bindings = ''
        bind --erase --mode insert --preset \cd
        bind --erase --mode visual --preset \cd
        bind --erase --preset \cd
      '';
    };

    shellInit = ''
      fish_vi_key_bindings
      set -U fish_greeting ""
    '';
  };
}
