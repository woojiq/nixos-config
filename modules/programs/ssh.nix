# NOTDECL: Create ssh key using `ssh-keygen -i` and use `ssh-copy-id <server-name>` to copy public key to servers.
# TODO: Replace manual key generation with `services.openssh.hostKeys` option.
{
  pkgs,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      openssh
    ];

    file.".ssh/config".text = let
      makePrxX = idx: lastOct: let
        Ip = "192.168.77.${toString lastOct}";
        idxStr = toString idx;
      in ''
        Host prx${idxStr}
          Hostname ${Ip}
          Port ${idxStr}032
          User root
      '';
    in ''
      Host is3
        Hostname 192.168.77.29
        User y.shymon

      Host is7
        Hostname 192.168.77.30
        User y.shymon

      Host is19
        Hostname 192.168.77.72
        User y.shymon

      Host wkz
        User y.shymon
        Hostname 192.168.73.141

      ${lib.strings.concatMapStrings (idx: (makePrxX idx 29) + "\n") [2 10 14 15 16]}
      ${lib.strings.concatMapStrings (idx: (makePrxX idx 30) + "\n") [1 3 4 5 6 7 8 9 11 12 13]}

      Host prx*
        HostKeyAlgorithms=+ssh-rsa
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null

      Host *
        ServerAliveInterval 120
    '';
  };
}
