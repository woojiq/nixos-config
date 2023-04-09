{ config, user, pkgs, ... }:

{
  imports =
    [ (import ../modules/desktop/hyprland/home.nix) ] ++
    (import ../modules/programs) ++
    (import ../modules/services/user);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # CLI
      unzip
      neofetch # System info
      fd # `find` alternative
      tokei # Code statistics
      tldr # Simplified `man`

      xdg-user-dirs
      xdg-utils

      # Developing
      ## Nix
      nil
      nixpkgs-fmt
      ## Rust
      rust-analyzer
      rustup
      gcc # Rustc needs `cc` linker
      openssl # Rust web crates need this (and pkg-config)
      pkg-config

      # Desktop application
      mpv # Media player
      evince # Pdf reader
      cinnamon.nemo # File manager
      google-chrome
      emote # Emoji picker
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
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig"; # Rust development
    };

    file.${config.home.sessionVariables.XDG_WALLPAPERS_DIR}.source = ../stuff/Wallpapers;

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
    bat = {
      enable = true;
      config = {
        color = "always";
      };
    };
    zoxide = {
      enable = true;
    };
    fzf = {
      enable = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
        "--preview '${pkgs.bat}/bin/bat {} 2>/dev/null || ${pkgs.exa}/bin/exa -a {}'"
        "-m"
      ];
      # TODO smart hidding. Some hidden files/dirs I need (.config, .gitignore), some - don't  (.cache, .cargo)
      defaultCommand = "${pkgs.fd}/bin/fd . \\$dir | sed 's@^\./@@'";
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bottom.enable = true;
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
      XDG_WALLPAPERS_DIR = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
  };
}
