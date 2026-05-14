{
  lib,
  fetchFromGitHub,
  nur,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  tmdb-index = python3Packages.buildPythonApplication {
    pname = "tmdb-index";
    version = "0-unstable-2026-05-14";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "tmdb-index";
      rev = "9237678049f1f17bb4b76abedc0303f7d9a366c4";
      hash = "sha256-ul2xeiG6gqcZ6QzEW5EmonQqCECrjMlaB+UiqhRmkAM=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      nur.repos.josh.polars
      tqdm
    ];

    meta = {
      description = "Compact TMDB external ID index";
      homepage = "https://github.com/josh/tmdb-index";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "tmdb-index";
      broken = lib.strings.versionOlder python3Packages.polars.version "1.30";
    };
  };
in
tmdb-index.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    tmdb-index = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        help =
          runCommand "test-tmdb-index-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ tmdb-index ];
            }
            ''
              tmdb-index --help
              touch $out
            '';
      };
    };
  }
)
