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
    version = "0.1.0-unstable-2025-04-07";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "c18040d75fbb2c1a04519527e7d00b4c1b12e518";
      hash = "sha256-VwWVoaCdL/gCU9O7zl54h7WHMguUROythFaYlFCA5l4=";
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
  finalAttrs: _previousAttrs:
  let
    imdb-plex-sync = finalAttrs.finalPackage;
  in
  {
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
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
  }
)
