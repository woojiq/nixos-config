# TODO add ssh-agent somehow to not write password every time
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      openssh
    ];

    file.".ssh/config".text = let
      is3ip = "192.168.77.29";
      is7ip = "192.168.77.30";
      makePrxX = idx: server: let
        getIp =
          if server == 3
          then is3ip
          else is7ip;
        idxStr = toString idx;
      in ''
        Host prx${idxStr}
          Hostname ${toString getIp}
          Port ${idxStr}032
          User root
      '';
    in ''
      Host is3
        Hostname ${is3ip}
        User y.shymon

      Host is7
        Hostname ${is7ip}
        User y.shymon

      Host wkz
        User y.shymon
        Hostname 192.168.73.141

      ${makePrxX 1 7}
      ${makePrxX 3 7}
      ${makePrxX 4 7}
      ${makePrxX 5 7}
      ${makePrxX 6 7}
      ${makePrxX 7 7}
      ${makePrxX 8 7}
      ${makePrxX 9 7}
      ${makePrxX 12 7}
      ${makePrxX 13 7}

      ${makePrxX 2 3}
      ${makePrxX 10 3}
      ${makePrxX 11 3}
      ${makePrxX 14 3}
      ${makePrxX 15 3}
      ${makePrxX 16 3}

      Host prx*
        HostKeyAlgorithms=+ssh-rsa
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null

      Host *
        ServerAliveInterval 120
    '';
  };
}
