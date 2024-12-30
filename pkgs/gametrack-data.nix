{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  gametrack-data = python3Packages.buildPythonApplication rec {
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
  };
in
gametrack-data.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    gametrack-data = finalAttrs.finalPackage;
  in
  {
    passthru.tests = {
      # TODO: Add --version test

      help =
        runCommand "test-gametrack-data-help"
          {
            nativeBuildInputs = [ gametrack-data ];
          }
          ''
            gametrack-data --help
            touch $out
          '';
    };
  }
)
