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
      rev = "f4d83f648ed4ab55616adccf6c05f08eec450fd7";
      hash = "sha256-8ezLcWlSFznuQIUKIDay0pyg4RbFC9zK7J0938+XLy4=";
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
