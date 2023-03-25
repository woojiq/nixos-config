_Heavily inspired from: https://github.com/MatthiasBenaets/nixos-config_  

### TODO
* Sway{idle + lock}
* Alt-tab
* Open terminal apps with wofi
* Sound/brightness inc/dec dunst notification
* Autosuspend
* Try KDE

### Might be fixed in the next app release
* Wezterm: nice cursor should appear when hovering link
* Wezterm: wofi should start term apps (shift+enter) in wezterm with `wezterm -e`
* Waybar: crashes when using wireplumber module #1852. Use `wireplumber` module instead of `pulseaudio`
* Tokei: colored output
* Keyd: Keyd neuters libinput's "disable while typing" for touchpads
* Rust-analyzer: private fields in test dir (zero2prod)

# License
The software is licensed under the [MIT License](LICENSE).

Note: MIT license does not apply to the packages built by Nixpkgs,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included in Nixpkgs, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.