final: prev: let
  overlays = [
    (import ./swappy.nix)
    (final: prev: {
      keyprod = prev.callPackage ./keyprod.nix {};
      my-scripts = prev.callPackage ./scripts.nix {};
    })
  ];
in
  # WTF
  prev.lib.composeManyExtensions overlays final prev
