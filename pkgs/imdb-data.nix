{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  imdb-data = python3Packages.buildPythonApplication rec {
    pname = "imdb-data";
    version = "0.1.0-unstable-2025-02-03";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "a9291a364750c2df07d92d0137694b48db85e78b";
      hash = "sha256-TGF2pGqiApR2ZT5m0L0HSvQPSQGEoAAMFVzcVM6feXg=";
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
