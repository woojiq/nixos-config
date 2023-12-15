final: prev: let
  overlays = [
    (import ./swappy.nix)
    (import ./tokei.nix)
    (import ./wezterm.nix)
    (final: prev: {
      i3-gnome-pomodoro = prev.callPackage ./i3-gnome-pomodoro.nix {};
    })
  ];
in
  prev.lib.composeManyExtensions overlays final prev
