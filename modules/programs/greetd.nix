{
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --remember --time --asterisks --cmd ${pkgs.hyprland}/bin/Hyprland";
      };
    };
  };
}
