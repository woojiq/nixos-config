{pkgs, ...}: {
  home.packages = with pkgs; [
    virt-manager # Gui for managing virtual machines
  ];

  dconf.settings = {
    # https://nixos.wiki/wiki/Virt-manager
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
