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
      commitizen # Conventional commit messages
      asciinema # Terminal session recorder

      xdg-user-dirs
      xdg-utils

      # Developing
      ## Nix
      nil
      nixpkgs-fmt

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

    file.${config.home.sessionVariables.WALLPAPERS_DIR}.source = ../misc/Wallpapers;

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
      defaultCommand = "${pkgs.fd}/bin/fd --type f . \\$dir | sed 's@^\./@@'";
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bottom.enable = true;
    gh = {
      enable = true;
    };
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    blueman-applet.enable = true;
    gammastep = {
      enable = true;
      dawnTime = "7:00-8:00";
      duskTime = "22:00-23:00";
      temperature.day = 6500;
      tray = true;
    };
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      # Enable searching for and installing unfree packages
      allowUnfree = true;
    }
  '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null; # `nemo` will anyway create this folder.
    music = null;
    publicShare = null;
    templates = null;
    videos = null;
    extraConfig = {
      SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      WALLPAPERS_DIR = "${config.home.homeDirectory}/Pictures/Wallpapers";
      HACKS_DIR = "${config.home.homeDirectory}/Hacks";
    };
  };
}
