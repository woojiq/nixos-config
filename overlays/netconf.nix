# NOTDECL: install license key
{
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  glib,
  bash,
  xterm,
  jre8,
}: let
  src = fetchTarball {
    url = "https://www.mg-soft.net/files/mgNetConfBrowser-2024a-deb.tar.gz";
    sha256 = "sha256:1pqhdj7lbvhqszhkbs3fsxn4i6nxz64vfs1r9nl17vhad7rjm0cf";
  };
in
  stdenv.mkDerivation {
    pname = "NetConfBrowser";
    system = "x86_64-linux";
    version = "2024a";
    inherit src;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    unpackPhase = let
      name = "mgNetConfBrowser-2024_12.1-1_x86_64.deb";
    in ''
      dpkg-deb -x $src/${name} deb
    '';

    buildInputs = [
      glib
    ];

    installPhase = ''
      mkdir -p $out/share
      cp -R deb/usr/share/ $out/
      cp -R deb/usr/local/ $out/opt

      substituteInPlace $out/share/applications/*.desktop --replace /usr/local/ $out/opt/
      substituteInPlace $out/opt/mg-soft/mgnetconfbrowser/bin/*.sh \
      --replace "/usr/local/" $out/opt/ \
      --replace "/bin/bash" "${bash}/bin/bash" \
      --replace "/usr/bin/xterm" "${xterm}/bin/xterm" \
      --replace "/usr/bin/java" "${jre8}/bin/java"

      ln -sf $out/opt/mg-soft/mgnetconfbrowser/bin $out/bin
      rm $out/bin/xdg-open
    '';
  }
