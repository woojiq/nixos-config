/*
Windows Guest w/ virt-manager:
* [FAST! Windows VM on Linux using QEMU / kvm / VirtIO // Ditch Your VirtualBox!](https://www.youtube.com/watch?v=Zei8i9CpAn0)
* [Install windows 10](https://getlabsdone.com/10-easy-steps-to-install-windows-10-on-linux-kvm/)
* Install spice guest tools
* [Setup shared folders](https://www.debugpoint.com/kvm-share-folder-windows-guest/)
* [Setup VFIO (untested)](https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/)
* [Windows-on-NixOS, part 2: Make it go fast!(untested)](https://nixos.mayflower.consulting/blog/2020/06/17/windows-vm-performance/)
*/
{
  user,
  pkgs,
  ...
}: {
  users = {
    users.${user}.extraGroups = ["libvirtd" "kvm"];
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
