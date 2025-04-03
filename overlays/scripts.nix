{
  lib,
  rustPlatform,
}: let
  root = ../scripts;
  manifest = lib.importTOML (root + /Cargo.toml);
in
  rustPlatform.buildRustPackage {
    pname = manifest.package.name;
    version = manifest.package.version;

    src = lib.fileset.toSource {
      inherit root;
      fileset = root;
    };

    # Ideally I'd like to have separate outputs (e.g. .bin1, .bin2, etc.), but I
    # don't know how to do that, so moving on.

    cargoLock.lockFile = root + /Cargo.lock;
  }
