# https://github.com/nrdxp/nrdos/blob/f4160da8e16b71b3e92abd7ce038341a1946724a/src/hardware/profiles/optimus.nix
{...}: {
  services.xserver.videoDrivers = ["nvidia"];

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

  programs = {
    steam = {
      enable = false;
    };
  };
}
