{ pkgs, ... }:

{
  imports = [ (import ../../programs/waybar.nix) ];

  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
  ];

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };
}
