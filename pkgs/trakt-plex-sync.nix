{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    __structuredAttrs = true;

    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-02-08";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "50f03d76c3b6442fec018b412c4805a555ea4e16";
      hash = "sha256-1TV6pD9RPKi68Ca67rrT5IpFzobeQrzTWT+WlPJMIhk=";
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
