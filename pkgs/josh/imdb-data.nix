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
    version = "0.1.0-unstable-2026-02-23";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "93e22692cd8988029c8e5440af5d436c38796e91";
      hash = "sha256-qdA9wnE47zDUmQMYN/2RyUqTNCe9HLV0eHzhNbYYaUA=";
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
  finalAttrs: previousAttrs:
  let
    imdb-data = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
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
    };
  }
)
