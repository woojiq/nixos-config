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
      neofetch # System info
      fd # `find` alternative
      tokei # Code statistics
      asciinema # Terminal session recorder
      ripgrep # `grep` alternative
      rclone # rsync for cloud storage
      eza # `ls` alternative
      hyprpicker # color picker
      trim-clipboard
      ## Networking
      tcpdump
      traceroute

      xdg-user-dirs
      xdg-utils

      # Developing
      ## Nix
      # TODO: Try nixd language-server.
      nil
      alejandra # code formatter

      # Desktop application
      mpv # Media player
      nemo # File manager
      eog # GNOME image viewer
      emote # Emoji picker
      telegram-desktop
      obs-studio
      netconf # Netconf protocol browser
      darktable # Photography workflow application
      # zed # Editor like VSCode
      # foliate # Read e-books/pdf

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
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
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
    mimeApps = {
      enable = true;
      # Use `file --mime-type <filename>` to get mime type
      # Check $XDG_DATA_DIRS to search for .desktop
      defaultApplications = let
        # Generate "$base/$list[i] = $value" attributes for each element of the list.
        forEachFileType = base: list: value: builtins.foldl' (accum: el: {"${base}/${el}" = value;} // accum) {} list;
      in
        {}
        // (forEachFileType "image" ["jpeg" "jpg" "png"] "org.gnome.eog.desktop")
        // (forEachFileType "video" ["mp4"] "mpv.desktop")
        // (forEachFileType "x-scheme-handler" ["http" "https"] "google-chrome.desktop")
        // (forEachFileType "text" ["html"] "google-chrome.desktop");
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
