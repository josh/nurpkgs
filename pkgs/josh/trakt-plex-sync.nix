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
    version = "0.1.0-unstable-2025-11-23";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-plex-sync";
      rev = "67df2b69fecf5c8050b0ca36702f270366fea590";
      hash = "sha256-92OT0fTmaQov9RdqMEci+JOPtjGqXE2kjRGjMxB9jLo=";
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
  _finalAttrs: previousAttrs: {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        # TODO: Add --version test
        # TODO: Add --help test
      };
    };
  }
)
