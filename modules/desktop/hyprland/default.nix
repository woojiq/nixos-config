{ pkgs, ... }:

{
  imports = [ (import ../../programs/waybar.nix) ];

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };
}
