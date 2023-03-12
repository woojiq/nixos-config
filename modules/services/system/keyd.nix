{ pkgs, ... }:

let
  config = ''
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
  environment.etc."keyd/defaut.conf".text = config;

  # https://discourse.nixos.org/t/how-to-start-a-daemon-properly-in-nixos/14019/2
  systemd.services.keyd = {
    description = "Keyd remapping daemon.";
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = true;
    serviceConfig = {
      ExecStart = "${pkgs.keyd}/bin/keyd";
      Restart = "always";
    };
  };
}
