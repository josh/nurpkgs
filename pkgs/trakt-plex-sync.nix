{
  lib,
  fetchFromGitHub,
  python3Packages,
  nur,
}:
python3Packages.buildPythonApplication rec {
  pname = "trakt-plex-sync";
  version = "0-unstable-2024-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "trakt-plex-sync";
    rev = "7024f64c72fadd3668c42dc7ec20cdafd8bf8357";
    hash = "sha256-O2FGdXvyxMQ8Oe3Me1Wxkw4gPmcKFF7l5J7Opiwv2Cg=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    nur.repos.josh.python3-lru-cache
    plexapi
    requests
  ];

  passthru.updateScriptVersion = "branch";

  meta = {
    description = "Sync Trakt history to Plex library";
    homepage = "https://github.com/josh/trakt-plex-sync";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "trakt-plex-sync";
  };
}
