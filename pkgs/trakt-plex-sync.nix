{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-01-13";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "4023f7ad03ec686e3f3cd6f37660a62addef0222";
      hash = "sha256-QVR6TCu1/OnxLeVxiNMlP1EiyyrsrxUhN/g9pbW7ytw=";
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
