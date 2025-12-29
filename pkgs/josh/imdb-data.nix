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
    version = "0.1.0-unstable-2025-12-29";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "355b65f811fa834a04b1be7c2eaad4a97567c75e";
      hash = "sha256-+U0vQjx2vogJ1K0kSAZS4lnrFx8EIjXQj699badbEbY=";
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
