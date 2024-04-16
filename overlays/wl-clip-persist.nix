(final: prev: {
  wl-clip-persist = prev.wl-clip-persist.overrideAttrs (old: rec {
    pname = "wl-clip-persist";
    version = "0.4.0";
    src = prev.fetchFromGitHub {
      owner = "Linus789";
      repo = "${pname}";
      rev = "5b1ba6fa1815511748032be8d7d0b894c14c07ef";
      hash = "sha256-uu9R+/8483YyuvMeot2sRs8ihSN1AEPeDjzRxB1P8kc=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (_: {
      name = "${pname}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-j478Zom5FCVLZNhWNeyIHk3EOtjS17yKrJHJASjKtmo=";
    });
  });
})
