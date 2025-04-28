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
    version = "0.1.0-unstable-2025-04-28";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "908acca4b08d45523ae7df84155a92e08fec3335";
      hash = "sha256-yfwXTCQucgFn9aqjFrVbUtj6k7MDoehYPaz87ZEf7N4=";
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
