{...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host is3
        Hostname 192.168.77.29

      Host is7
        Hostname 192.168.77.30

      Host wkz
        Hostname 192.168.73.141

      Host *
        User y.shymon
        ServerAliveInterval 120
    '';
  };
}
