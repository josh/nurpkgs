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
    version = "0.1.0-unstable-2025-05-12";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "bcd907c47c0433c5e26693fdfc3fb440ae832b0e";
      hash = "sha256-dfh3/mkTEyFIpOY5TpIgYTWSrozUnmQqPgu6L+3PZVQ=";
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
