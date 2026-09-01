{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";

                extraArgs = [
                  "-n"
                  "boot"
                ];
              };
            };

            root = {
              size = "225G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";

                extraArgs = [
                  "-L"
                  "nixos"
                ];
              };
            };

            home = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";

                extraArgs = [
                  "-L"
                  "home"
                ];
              };
            };
          };
        };
      };
    };
  };
}
