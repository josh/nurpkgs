{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  imdb-trakt-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-trakt-sync";
    version = "0.1.0-unstable-2025-02-03";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-trakt-sync";
      rev = "8eb4608f9b5d87d5c3265851369a1f939fd3e24e";
      hash = "sha256-Qkqoee6wYxNMeRoHi2e8N7xKCE/zgDshxHzn951I29o=";
    };

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      requests
    ];

    meta = {
      description = "Sync IMDb watchlist and ratings to Trakt";
      homepage = "https://github.com/josh/imdb-trakt-sync";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "imdb-trakt-sync";
    };
  };
in
imdb-trakt-sync.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    imdb-trakt-sync = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "branch";

    passthru.tests = {
      # TODO: Add --version test

      help =
        runCommand "test-imdb-trakt-sync-help"
          {
            nativeBuildInputs = [ imdb-trakt-sync ];
          }
          ''
            imdb-trakt-sync --help
            touch $out
          '';
    };
  }
)
