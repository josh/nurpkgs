{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  imdb-data = python3Packages.buildPythonApplication rec {
    pname = "imdb-data";
    version = "0.1.0-unstable-2025-01-29";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "28ec5daeea60aa58a8bc7d36a24cb72a8c52ad84";
      hash = "sha256-hB9df+7o8tdoWAtSmYkYKoANolHhVu5LPtUUAFTSMQ4=";
    };

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      parsel
      requests
    ];

    meta = {
      description = "IMDB personal lists and ratings data scaper";
      homepage = "https://github.com/josh/imdb-data";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "imdb-data";
    };
  };
in
imdb-data.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    imdb-data = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "branch";

    passthru.tests = {
      # TODO: Add --version test

      help =
        runCommand "test-imdb-data-help"
          {
            nativeBuildInputs = [ imdb-data ];
          }
          ''
            imdb-data --help
            touch $out
          '';
    };
  }
)
