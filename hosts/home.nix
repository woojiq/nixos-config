{
  config,
  user,
  pkgs,
  ...
}: {
  imports =
    import ../modules/programs/home-default.nix;

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
      commitizen # Conventional commit messages
      asciinema # Terminal session recorder
      ripgrep # `grep` alternative

      xdg-user-dirs
      xdg-utils

      # Developing
      ## Nix
      nil
      alejandra

      # Desktop application
      mpv # Media player
      evince # Pdf reader
      cinnamon.nemo # File manager
      google-chrome
      emote # Emoji picker
      telegram-desktop
      obs-studio
      # TODO add gnome.pomodoro to drv and manage PATH somehow
      gnome.pomodoro
      i3-gnome-pomodoro
    ];

    pointerCursor = {
      gtk.enable = true;
      name = "macOS-BigSur-White";
      package = pkgs.apple-cursor;
      size = 24;
    };

    sessionVariables = {
      # Possibilty of negative side-effects
      SHELL = "${pkgs.fish}/bin/fish";
      TERMINAL = "${pkgs.wezterm}/bin/wezterm";

      # Case-insensitive Less pager
      LESS = "-iR";
    };

    file = {
      ${config.home.sessionVariables.WALLPAPERS_DIR}.source = ../misc/wallpapers;
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
        "--preview '${pkgs.bat}/bin/bat {} 2>/dev/null || ${pkgs.eza}/bin/eza -a {}'"
        "-m"
      ];
      # TODO smart hidding. Some hidden files/dirs I need (.config, .gitignore), some - don't  (.cache, .cargo)
      # Find both files and symlinks
      defaultCommand = "${pkgs.fd}/bin/fd -tf -tl . \\$dir | sed 's@^\./@@'";
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    };
    tealdeer.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish.shellInit = ''
      # Disable noise from direnv
      set -x DIRENV_LOG_FORMAT ""
    '';

    bottom.enable = true;
    gh = {
      enable = true;
    };
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    firefox.enable = true;
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

  dconf.settings = {
    # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Allows install unfree pkgs from `nix-shell` command
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
