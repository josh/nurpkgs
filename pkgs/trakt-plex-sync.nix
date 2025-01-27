{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-01-27";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "52b28040b0de6a9be5d47a54973a247f2908cee1";
      hash = "sha256-NWmJmTwCrCpP7kD6aM39L5U7bjZUzIj/UNPOgDmtD5U=";
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
