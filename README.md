_Heavily inspired from: https://github.com/MatthiasBenaets/nixos-config_

### TODO
* Alt-tab
* Sound/brightness inc/dec dunst notification (wob)

### FIX
* Keyd: Keyboard stops working after `nixos-rebuild` with `nix-collect-garbage -d`
* Take advantage of cachix (helix + hyprland)

### Might be fixed/broken in the next app release
* Waybar: crashes when using wireplumber module #1852. Use `wireplumber` module instead of `pulseaudio`
* Tokei: colored output
* [Helix](https://github.com/helix-editor/helix/pull/5379): I'll probably want to use the old version after this merge

# License
The software is licensed under the [MIT License](LICENSE).

Note: MIT license does not apply to the packages built by Nixpkgs,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included in Nixpkgs, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.