{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
}:
let
  imdb-trakt-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-trakt-sync";
    version = "0.1.0-unstable-2025-01-04";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-trakt-sync";
      rev = "b5da70e69016e84463f43e81b2022c0ec467434e";
      hash = "sha256-8m4EY/vp6EbqJ/PWX2kluzB57Lc4b9iBWd7b2FABr/s=";
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
