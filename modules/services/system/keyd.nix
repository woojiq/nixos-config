{ config, pkgs, ... }:

let
  configFile = ''
    [ids]
    *

    [main]
    capslock = overload(control, esc)
    rightalt = layer(rightalt)

    [rightalt]
    j = down
    k = up
    h = left
    l = right
  '';
in
{
  environment.systemPackages = [ pkgs.keyd ];
  environment.etc."keyd/default.conf".text = configFile;

  # https://discourse.nixos.org/t/how-to-start-a-daemon-properly-in-nixos/14019/2
  systemd.services.keyd = {
    description = "Keyd remapping daemon.";
    wantedBy = [ "multi-user.target" ];

    restartTriggers = [
      config.environment.etc."keyd/default.conf".source
    ];

    serviceConfig = {
      ExecStart = "${pkgs.keyd}/bin/keyd";
      Restart = "always";
    };
  };
}
