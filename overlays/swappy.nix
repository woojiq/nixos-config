# Multi-layout keybindings
final: prev: {
  swappy = prev.swappy.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ../patches/swappy-multi-layout.patch
      ];
  });
}
