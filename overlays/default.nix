final: prev: let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
    (final: prev: {
      netconf = prev.callPackage ./netconf.nix {};
      scripts = prev.callPackage ./scripts.nix {};
    })
  ];
in
  # WTF
  prev.lib.composeManyExtensions overlays final prev
