{ pkgs, ... }:

let
  light = "${pkgs.light}/bin/light";
  hyprland = "${pkgs.hyprland}/bin/Hyprland";
in
{
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec ${hyprland}
      fi
      # Set minimum brightness value
      ${light} -N 5
    '';

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      wl-clip-persist
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
    };
    light.enable = true;
  };
}
