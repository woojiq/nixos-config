{ config, user, pkgs, ... }:

{
  imports =
    [ (import ../modules/desktop/hyprland/home.nix) ] ++
    (import ../modules/programs) ++
    (import ../modules/services/user);

  home = {
    username = "${ user}";
    homeDirectory = "/home/${ user}";

    packages = with pkgs; [
      # Utilities
      unzip
      file
      powerstat # WAT consumption
      neofetch
      bat
      fd

      # Used by another apps
      xdg-user-dirs
      xdg-utils

      # Programming
      nil
      nixpkgs-fmt
      rust-analyzer
      cargo

      # Desktop application
      mpv
      evince
      cinnamon.nemo
      google-chrome
    ];

    pointerCursor = {
      gtk.enable = true;
      name = "macOS-BigSur-White";
      package = pkgs.apple-cursor;
      size = 24;
    };

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "${config.home.sessionVariables.EDITOR}";
      # Zero Impact
      # TERMINAL = "wezterm";
      # TERM = "wezterm";
    };

    stateVersion = "22.11";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Juno";
      package = pkgs.juno-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs = {
    home-manager.enable = true;
    exa.enable = true;
    autojump = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    blueman-applet.enable = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null; # Idk how, btw this dir was created. Probably, `nemo` has created this folder
    music = null;
    publicShare = null;
    templates = null;
    videos = null;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };
}
