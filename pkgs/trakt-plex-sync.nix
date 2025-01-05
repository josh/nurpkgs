{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-01-04";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "b06d768271f40d3a1247209dde1da00d89fd57f5";
      hash = "sha256-bN1tJWN6ev966iGsNczRFumcw4MM2gSMzCPulcU7cys=";
    };

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      nur.repos.josh.python3-lru-cache
      plexapi
      requests
    ];

    meta = {
      description = "Sync Trakt history to Plex library";
      homepage = "https://github.com/josh/trakt-plex-sync";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "trakt-plex-sync";
    };
  };
in
trakt-plex-sync.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    passthru.updateScriptVersion = "branch";

    passthru.tests = {
      # TODO: Add --version test
      # TODO: Add --help test
    };
  }
)
