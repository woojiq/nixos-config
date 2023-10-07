# Windows Guest w/ virt-manager
# * [Install windows 10](https://getlabsdone.com/10-easy-steps-to-install-windows-10-on-linux-kvm/)
# * Install spice guest tools
# * [Setup shared folders](https://www.debugpoint.com/kvm-share-folder-windows-guest/)
# * [Setup VFIO (untested)](https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/)
{
  user,
  pkgs,
  ...
}: {
  users = {
    users.${user}.extraGroups = ["libvirtd"];
  };

  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };
  };
}
