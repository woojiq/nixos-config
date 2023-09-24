# INFO Adds colored output. It will become useless after the release of tokei 12.1.2
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/misc/tokei/default.nix#L5
(final: prev: {
  tokei = prev.tokei.overrideAttrs (old: rec {
    pname = "tokei";
    src = prev.fetchFromGitHub {
      owner = "XAMPPRocky";
      repo = "${pname}";
      rev = "ae77e1945631fd9457f7d455f2f0f2f889356f58";
      hash = "sha256-oifeBvwoqpHVdRL4H3rFRmMquxRJNmSApR2yuTdIEdQ=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (_: {
      name = "${pname}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-38W3Icv/uMR9MGgNhkwDkeGy60GwfXEvafNGx5YTBoc=";
    });
  });
})
