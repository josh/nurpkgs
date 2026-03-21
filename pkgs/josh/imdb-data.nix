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
    version = "0.1.0-unstable-2026-03-21";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-data";
      rev = "b7393a963b8cefb028a56cb90c900e05ee489b37";
      hash = "sha256-949mWf1KZ4Y05VkSPgkiVRywUDkTnZvKfrJZ/z2Dsw4=";
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
