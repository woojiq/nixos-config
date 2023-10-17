{
  stdenv,
  fetchFromGitHub,
  python3,
  python3Packages,
}: let
  repo = "i3-gnome-pomodoro";
  rev = "b5ffdac2406011f282131726743ea73f3385d770";
in
  stdenv.mkDerivation {
    pname = "${repo}";
    version = "${rev}";
    src = fetchFromGitHub {
      owner = "kantord";
      repo = "${repo}";
      rev = "${rev}";
      hash = "sha256-upJnYWsOUWT+12nhdycYKoctwrt8VhTutuatsr7ICKk=";
    };

    nativeBuildInputs = [
      python3Packages.wrapPython
    ];
    propagatedBuildInputs = [
      python3
    ];

    pythonPath = with python3Packages; [
      pydbus
      click
      i3ipc
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/pomodoro-client.py $out/bin/${repo}
      chmod +x $out/bin/${repo}
    '';
    postFixup = "wrapPythonPrograms";
  }
