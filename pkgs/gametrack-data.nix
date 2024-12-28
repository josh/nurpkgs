{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "gametrack-data";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gametrack-data";
    rev = "v${version}";
    hash = "sha256-4A1vM0DtaB+alnLnwD/Y8tdnQwAWUXH3r+Cxr4C4DaQ=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  passthru.updateScriptVersion = "stable";

  meta = {
    description = "Export GameTrack data to CSV";
    homepage = "https://github.com/josh/gametrack-data";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "gametrack-data";
  };
}
