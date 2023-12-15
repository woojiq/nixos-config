{
  pkgs,
  user,
  options,
  ...
}: {
  imports =
    [(import ./hardware-configuration.nix)]
    ++ (import ../modules/programs/nix-default.nix);

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Kyiv";

  users = {
    users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "video" "audio" "docker"];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    # Flicker-free (without text) graphical boot process
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet" "udev.log_level=3" "resume_offset=151552"];
    plymouth.enable = true;
    # Configure hibernation (resume_offset cannot be precalculated on fresh system):
    # https://discourse.nixos.org/t/is-it-possible-to-hibernate-with-swap-file/2852
    # Calculate offset on swap file using:
    # filefrag -v /var/swapfile | awk '{if($1=="0:"){print $4}}'
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 20;
    }
  ];

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    rtkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    # man-pages-posix
  ];

  documentation.man.generateCaches = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "InconsolataLGC"
      ];
    })
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this (what is Jack? xd)
      # jack.enable = true;
    };
    gvfs.enable = true; # https://nixos.wiki/wiki/Nautilus
    blueman.enable = true;
    # Don't see any difference actually
    thermald = {
      enable = true;
    };
    openvpn.servers = {
      work = {
        config = "config /etc/openvpn/client.conf";
        autoStart = false;
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.Experimental = true; # Device battery status: https://askubuntu.com/a/1420501
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };

  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  i18n = {
    supportedLocales = options.i18n.supportedLocales.default ++ ["uk_UA.UTF-8/UTF-8"];
    extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    nixPath = ["nixpkgs=${pkgs.path}"];
    extraOptions = ''
      experimental-features = nix-command flakes
      # To protect your nix-shell against garbage collection
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = "23.11";
}
