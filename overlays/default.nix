final: prev: let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
    (final: prev: {
      google-chrome = prev.google-chrome.override {
        commandLineArgs = prev.lib.concatStringsSep " " [
          # Bro, I hate new UI so much.
          "--disable-features=ChromeRefresh2023NTB"
          "--disable-features=CustomizeChromeSidePanel"
          # TODO: Not sure if it boost download speed.
          "--enable-features=ParallelDownloading"
        ];
      };

      netconf = prev.callPackage ./netconf.nix {};
    })
  ];
in
  prev.lib.composeManyExtensions overlays final prev
