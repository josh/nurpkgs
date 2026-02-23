{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  tmdb-index = python3Packages.buildPythonApplication {
    pname = "tmdb-index";
    version = "1.0.0-unstable-2026-02-23";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "tmdb-index";
      rev = "616413f4e40a3349051fb35e11ceba9effdd6c7d";
      hash = "sha256-Rdb2NRhiEuoZ7mFe2H0qflTxK3MzRMdeSSK0rfaoATM=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      polars
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
