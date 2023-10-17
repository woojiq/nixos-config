{pkgs, ...}: let
  uri = "qemu:///system";
in {
  home = {
    packages = with pkgs; [
      virt-manager # Gui for managing virtual machines
    ];
    sessionVariables.LIBVIRT_DEFAULT_URI = "${uri}";
  };

  dconf.settings = {
    # https://nixos.wiki/wiki/Virt-manager
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["${uri}"];
      uris = ["${uri}"];
    };
  };
}
