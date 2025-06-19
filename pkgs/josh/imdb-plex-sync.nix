{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  imdb-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-plex-sync";
    version = "0.1.1-unstable-2025-06-19";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "f15671f3ca801b09db67e3a1c83268533dbc6add";
      hash = "sha256-U0/bSqTshrAh4yBRmgsGFoCleioq68oit2KsYrIsm5s=";
    };

    pyproject = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      plexapi
    ];

    meta = {
      description = "Sync IMDb watchlist to Plex watchlist";
      homepage = "https://github.com/josh/imdb-plex-sync";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "imdb-plex-sync";
    };
  };
in
imdb-plex-sync.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    imdb-plex-sync = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        # TODO: Add --version test

        help =
          runCommand "test-imdb-plex-sync-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ imdb-plex-sync ];
            }
            ''
              imdb-plex-sync --help
              touch $out
            '';
      };
    };
  }
)
