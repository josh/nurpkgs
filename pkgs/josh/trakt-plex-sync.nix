{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
  nix-update-script,
}:
let
  trakt-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "trakt-plex-sync";
    version = "0.1.0-unstable-2025-05-05";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "877eab9625f54a5e28aad2cc1cbeb44f7f9a9771";
      hash = "sha256-T1JHu+DApIqqJlg8V8tklG0RhJ2pCrWwT4MqnT6tnmE=";
    };

    pyproject = true;
    __structuredAttrs = true;

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
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      # TODO: Add --version test
      # TODO: Add --help test
    };
  }
)
