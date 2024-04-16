final: prev: let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
    (final: prev: {
      google-chrome = prev.google-chrome.override {
        commandLineArgs = prev.lib.concatStringsSep " " [
          # Bro, I hate new UI so much (and "Continue journey")
          "--disable-features='ChromeRefresh2023NTB,CustomizeChromeSidePanel,Journeys'"
          # TODO: Not sure if ParallelDownloading boosts download speed.
          "--enable-features='ParallelDownloading'"
        ];
      };

      netconf = prev.callPackage ./netconf.nix {};
    })
    (import ./wezterm.nix)
    (import ./wl-clip-persist.nix)
  ];
in
  prev.lib.composeManyExtensions overlays final prev
