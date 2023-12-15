# https://github.com/nrdxp/nrdos/blob/f4160da8e16b71b3e92abd7ce038341a1946724a/src/hardware/profiles/optimus.nix
{...}: {
  services.xserver.videoDrivers = ["nvidia"];

  # Fixes problems with hardware acceleration in Chrome.
  # But sometimes can't startup Hyprland.
  # boot.blacklistedKernelModules = ["nvidia-drm"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
