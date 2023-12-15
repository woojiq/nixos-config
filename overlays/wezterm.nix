# INFO Fix crash when opening with current version of Hyprland
# Remove once WezTerm has a new release and updates
# Pasted from https://github.com/Anomalocaridid/dotfiles/blob/4632761430b7b5fc4de59070af689c0fff1680de/pkgs/default.nix#L12
(final: prev: {
  wezterm = prev.wezterm.overrideAttrs (old: rec {
    pname = "wezterm";
    version = "unstable-2023-11-23";
    src = prev.fetchFromGitHub {
      owner = "wez";
      repo = "${pname}";
      rev = "6a58a5ce94f186884ec70a60b5afbd728521b1c5";
      fetchSubmodules = true;
      hash = "sha256-QXZjGIw5LvK+frigdCYGVOjLHM3Fnnqqi5FEySaKExs=";
    };
    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "xcb-1.2.1" = "sha256-zkuW5ATix3WXBAj2hzum1MJ5JTX3+uVQ01R1vL6F1rY=";
        "xcb-imdkit-0.2.0" = "sha256-L+NKD0rsCk9bFABQF4FZi9YoqBHr4VAZeKAWgsaAegw=";
      };
    };
  });
})
