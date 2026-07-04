{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  systemd,
  sqlite,
}: let
  name = "keyprod";
in
  rustPlatform.buildRustPackage {
    pname = name;
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "woojiq";
      repo = "keyprod";
      rev = "plugin-stat";
      hash = "sha256-UgVGnSqpEBja44kPNSdsPeiosKvBm3X3PT5ZfEVgGd4=";
    };

    cargoHash = "sha256-Ya/pUKGCaApIkYqsJN2rEIsGo+QWE4B+Ul0sXES8OLs=";

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];
    buildInputs = [
      systemd
      sqlite
    ];

    meta = {
      mainProgram = name;
    };
  }
