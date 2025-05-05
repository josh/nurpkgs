{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  imdb-data = python3Packages.buildPythonApplication rec {
    pname = "imdb-data";
    version = "0.1.0-unstable-2025-05-05";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "5823283c1b75cee995346179dd5b5127f380e6ca";
      hash = "sha256-dVpAou4k6y0u/w51kxU2N3Y89Oqba4agHuXykIr0LkY=";
    };

    pyproject = true;
    __structuredAttrs = true;

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
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      # TODO: Add --version test

      help =
        runCommand "test-imdb-data-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ imdb-data ];
          }
          ''
            imdb-data --help
            touch $out
          '';
    };
  }
)
