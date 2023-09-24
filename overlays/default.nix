final: prev:
let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
  ];
in
prev.lib.composeManyExtensions overlays final prev
