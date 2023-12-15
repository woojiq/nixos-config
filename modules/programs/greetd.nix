{
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --remember --time --asterisks --cmd ${pkgs.hyprland}/bin/Hyprland";
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/248323
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet - greeter greeter"
  ];
}
