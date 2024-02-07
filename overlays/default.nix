final: prev: let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
    (final: prev: {
      # i3-gnome-pomodoro = prev.callPackage ./i3-gnome-pomodoro.nix {};

      google-chrome = prev.google-chrome.override {
        commandLineArgs = prev.lib.concatStringsSep " " [
          # Disable new UI (I hate right-click popup spacing)
          "--disable-features=ChromeRefresh2023NTB"
        ];
      };

      netconf = prev.callPackage ./netconf.nix {};
    })
  ];
in
  prev.lib.composeManyExtensions overlays final prev
