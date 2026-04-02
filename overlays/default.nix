final: prev: let
  overlays = [
    (import ./swappy.nix)
    (final: prev: {
      netconf = prev.callPackage ./netconf.nix {};
      keyprod = prev.callPackage ./keyprod.nix {};
      scripts = prev.callPackage ./scripts.nix {};
    })
  ];
in
  # WTF
  prev.lib.composeManyExtensions overlays final prev
