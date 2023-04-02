{ ... }:

# Doesn't work)
{
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications
  programs.dconf.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmawayland";
    };
    desktopManager.plasma5.enable = true;
  };

  environment.plasma5.excludePackages = [
    # TODO
  ];
}
