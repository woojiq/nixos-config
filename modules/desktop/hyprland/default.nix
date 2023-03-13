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
      hyprpaper
    ];
  };

  programs.hyprland = {
    enable = true;
    # I don't see a difference. Probably because I use only an integrated gpu
    # nvidiaPatches = true;
  };
}
