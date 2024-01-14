{
  config,
  user,
  pkgs,
  ...
}: {
  imports =
    (import ../modules/programs/home-default.nix)
    ++ [(import ../modules/globals.nix)];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # CLI
      unzip
      file
      neofetch # System info
      fd # `find` alternative
      tokei # Code statistics
      asciinema # Terminal session recorder
      ripgrep # `grep` alternative
      ## Networking
      tcpdump
      traceroute

      xdg-user-dirs
      xdg-utils

      # Developing
      ## Nix
      nil
      alejandra # code formatter

      # Desktop application
      mpv # Media player
      cinnamon.nemo # File manager
      google-chrome
      emote # Emoji picker
      telegram-desktop
      obs-studio
      netconf # Netconf protocol browser
    ];

    pointerCursor = {
      gtk.enable = true;
      name = "macOS-BigSur-White";
      package = pkgs.apple-cursor;
      size = 24;
    };

    sessionVariables = {
      # Case-insensitive Less pager
      LESS = "-iR";
    };

    file = {
      ${config.home.sessionVariables.WALLPAPERS_DIR}.source = ../misc/wallpapers;
    };

    stateVersion = "23.11";
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
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1;
    '';
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
    eza.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    fzf = {
      enable = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
        "--preview '${pkgs.bat}/bin/bat -f {} -f 2>/dev/null || ${pkgs.eza}/bin/eza -a {}'"
        "-m"
      ];
      # Find both files and symlinks
      defaultCommand = "${pkgs.fd}/bin/fd -tf -tl . \\$dir | sed 's@^\./@@'";
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    };
    tealdeer.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    bottom = {
      enable = true;
      settings.flags = {
        battery = true;
        group_processes = true;
        basic = true;
      };
    };
    nix-index.enable = true;
    firefox.enable = true;
    foot.enable = true;
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    gammastep = {
      enable = true;
      dawnTime = "7:00-8:00";
      duskTime = "22:00-23:00";
      temperature.day = 6500;
      tray = true;
    };
  };

  dconf.settings = {
    # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Allows install unfree pkgs from nix-shell
  xdg = {
    configFile = {
      "nixpkgs/config.nix".text = ''
        {
          # Enable searching for and installing unfree packages
          allowUnfree = true;
        }
      '';
      # Enables pretty-printing rust in `gdb`
      "gdb/gdbinit".text = "set auto-load safe-path /nix/store";
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null; # `nemo` will anyway create this folder.
    documents = "${config.home.homeDirectory}/docs";
    music = null;
    publicShare = null;
    templates = null;
    videos = null;
    extraConfig = {
      SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      WALLPAPERS_DIR = "${config.home.homeDirectory}/Pictures/Wallpapers";
      CODE_DIR = "${config.home.homeDirectory}/code";
    };
  };
}
