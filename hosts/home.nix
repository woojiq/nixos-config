{
  config,
  user,
  pkgs,
  ...
}: let
  /*
  * Trim clipboard contents. It is designed to trim from the beginning of each
  * line (line number + some stuff). This is useful when copying via terminal
  * from helix with mouse support disabled.
  */
  trim-clipboard = let
    clip = "${pkgs.wl-clipboard}/bin";
  in
    pkgs.writeShellScriptBin "trim-clipboard" ''
      ${clip}/wl-paste | sed -r -e 's/^[^0-9]*[[:digit:]]+.//g' -e 's/╎|▍//g' | ${clip}/wl-copy
    '';
in let
  cursorTheme = {
    name = "macOS-White";
    package = pkgs.apple-cursor;
    size = 26;
  };
in {
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
      fastfetch # System info
      fd # `find` alternative
      tokei # Code statistics
      ripgrep # `grep` alternative
      rclone # rsync for cloud storage
      eza # `ls` alternative
      hyprpicker # color picker
      traceroute
      # wireguard-tools
      brightnessctl

      # Scripts
      trim-clipboard
      my-scripts
      keyprod # Track keyboard statistics

      xdg-user-dirs
      xdg-utils

      # https://github.com/NixOS/nixpkgs/issues/164021
      libheif
      libheif.out # HEIC image previews in file manager

      # Developing
      ## Nix
      # TODO: Try nixd language-server.
      nil
      alejandra # code formatter
      tinymist # typst lsp

      # Desktop application
      nemo # File manager
      eog # GNOME image viewer
      emote # Emoji picker
      telegram-desktop
      obs-studio
      gimp3 # Image processing
      # glogg # Log viewer
      # darktable # Photography workflow application
      # foliate # Read e-books/pdf
      anki # Learn words
      pavucontrol # Audio settings
      libreoffice # Office suite.
      qbittorrent

      cursorTheme.package
    ];

    pointerCursor =
      cursorTheme
      // {
        gtk.enable = true;
      };

    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
      # Case-insensitive Less pager
      LESS = "-iR";
    };

    stateVersion = "23.11";
  };

  gtk = {
    inherit cursorTheme;
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
    gtk4 = {
      theme = config.gtk.theme;
      extraConfig.gtk-application-prefer-dark-theme = 1;
    };
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
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
      # TODO: use "bind" to add directories and show only files by default
      # Find files, symlinks and dirs
      defaultCommand = "${pkgs.fd}/bin/fd -tf -tl -td . \\$dir | sed 's@^\./@@'";
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    };
    tealdeer.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
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
    firefox = {
      enable = true;
      # FIXME: set state version 26.05 and remove this line
      # configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
    foot.enable = false;

    mpv = {
      enable = true;
      scripts = [];
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        font-size = 18;
        # fish is not set as a default shell because ghostty is mainly used as a backup option when
        # wezterm is broken after upgrade.
      };
    };

    gpg = {
      enable = false;
    };
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    gammastep = {
      enable = true;
      dawnTime = "7:00-7:30";
      duskTime = "21:30-22:00";
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
      # Some app overwrites mimeapps all the time.
      "mimeapps.list".force = true;
    };
    terminal-exec = {
      enable = true;
      # wezterm doesn't implement the xdg-terminal-exec specification yet:
      # https://github.com/wezterm/wezterm/issues/7129
      # Currently ghostty is used.
    };
    mimeApps = {
      enable = true;
      # Use `file --mime-type <filename>` to get mime type
      # Check $XDG_DATA_DIRS to search for .desktop
      defaultApplications = let
        # Generate "$base/$list[i] = $value" attributes for each element of the list.
        forEachFileType = base: list: value: builtins.foldl' (accum: el: {"${base}/${el}" = value;} // accum) {} list;
      in
        {}
        // (forEachFileType "image" ["jpeg" "jpg" "png" "heic" "heif"] "org.gnome.eog.desktop")
        // (forEachFileType "video" ["mp4" "mov"] "mpv.desktop")
        // (forEachFileType "audio" ["x-mod"] "mpv.desktop")
        // (forEachFileType "x-scheme-handler" ["http" "https"] "google-chrome.desktop")
        // (forEachFileType "text" ["html"] "google-chrome.desktop");
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    # documents = true;
    # projects = true;
    # pictures = true;
    # download = true;
    # videos = true;
    desktop = null; # `nemo` will anyway create this folder.
    music = null;
    publicShare = null;
    templates = null;
    extraConfig = {
      GDRIVE = "${config.home.homeDirectory}/Gdrive";

      SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
      WALLPAPERS = "${config.xdg.userDirs.pictures}/Wallpapers";
      BACKUP = "${config.xdg.userDirs.documents}/backup";
      BOOKS = "${config.xdg.userDirs.documents}/books";
      OBS = "${config.xdg.userDirs.videos}/obs";
      VMS = "${config.xdg.userDirs.documents}/vms";
    };
    setSessionVariables = true;
  };

  systemd.user = {
    services = {
      gdrive-sync = {
        Unit = {
          Description = "Google Drive sync folder";
          StartLimitBurst = 3;
          StartLimitIntervalSec = "10min";
        };

        Service = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = "1min";
          ExecStart = let
            gdrive-sync = let
              rclone = "${pkgs.rclone}/bin/rclone";
              notify-send = "${pkgs.libnotify}/bin/notify-send";
            in
              pkgs.writeShellScriptBin "gdrive-sync" ''
                set -euxo pipefail

                if ${rclone} sync ${config.home.sessionVariables.XDG_GDRIVE_DIR} gdrive:/rclone -v; then
                  ${notify-send} -u normal -t 0 "Gdrive sync succeed";
                else
                  ${notify-send} -u critical -t 0 "Gdrive sync failed" "rclone sync failed. Check journalctl --user -xeu gdrive-sync.service";
                  exit 1
                fi
              '';
          in "${gdrive-sync}/bin/gdrive-sync";
        };
      };
    };

    timers = {
      gdrive-sync = {
        Unit.Description = "Run gdrive sync daily";

        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };

        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
