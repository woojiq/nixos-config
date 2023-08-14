{ pkgs, ... }:

let
  light = "${pkgs.light}/bin/light";
in
{
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
      # Set minimum brightness value
      ${light} -N 5
    '';

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };

  programs = {
    hyprland = {
      enable = true;
    };
    light.enable = true;
  };
}
