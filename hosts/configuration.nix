{ pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../modules/desktop/hyprland/default.nix) ] ++
    # [ (import ../modules/desktop/kde/default.nix) ] ++
    (import ../modules/services/system);

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
    # shell = pkgs.fish; # Fish doesn't take env vars when using rootless-docker
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
    kernelParams = [ "quiet" "udev.log_level=3" ];
    plymouth.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    rtkit.enable = true;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
    (google-fonts.override {
      fonts = [
        "Fredoka One"
      ];
    })
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # environment = {
  #   systemPackages = with pkgs; [
  #   ];
  # };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };
    gvfs.enable = true; # https://nixos.wiki/wiki/Nautilus
    blueman.enable = true;

    # Chad moment: https://github.com/NixOS/nixpkgs/pull/221321
    keyd = {
      enable = true;
      settings = {
        main = {
          capslock = "overload(control, esc)";
          rightalt = "layer(rightalt)";
        };
        rightalt = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.Experimental = true; # Device battery status: https://askubuntu.com/a/1420501
    };
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 4d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      # To protect your nix-shell against garbage collection
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = "22.11";
}

