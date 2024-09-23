{...}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # https://nixos.wiki/wiki/Nvidia#Modifying_NixOS_Configuration
    nvidia = {
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      # GeForce GTX 1050 Ti Mobile is not supported.
      open = false;
      modesetting.enable = true;
      powerManagement = {
        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        # Sleep doesn't work if enable = true.
        enable = false;
        finegrained = true;
      };
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
