{ pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../modules/desktop/hyprland/default.nix) ] ++
    (import ../modules/services/system);

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
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

    # Chad moment: https://github.com/NixOS/nixpkgs/pull/221321
    keyd = {
      enable = true;
      keyboards = {
        default = {
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
      substituters = [
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
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

  system.stateVersion = "23.05";
}

