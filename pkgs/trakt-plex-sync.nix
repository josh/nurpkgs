{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-02-03";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "8d3861a28a8e66414f56b56d7613af6ad81838d0";
      hash = "sha256-eps6OR8wwm95+NSr6XEiyuSY38Xx5RGD/gXqZqrqE9k=";
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
