{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  imdb-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-plex-sync";
    version = "0.1.0-unstable-2024-12-28";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "dc9421e09acc73c78c875744947a4afa6dba1c98";
      hash = "sha256-5gNh+Y1edtWkMW1oTY9qeVl1QSDXfnubot4+xj2XQsE=";
    };

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      plexapi
    ];

    passthru.updateScriptVersion = "branch";

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
    passthru.tests = {
      # TODO: Add --version test

      help =
        runCommand "test-imdb-plex-sync-help"
          {
            nativeBuildInputs = [ imdb-plex-sync ];
          }
          ''
            imdb-plex-sync --help
            touch $out
          '';
    };
  }
)
