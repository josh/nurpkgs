{
  lib,
  fetchFromGitHub,
  writeText,
  python3Packages,
  nur,
}:
python3Packages.buildPythonApplication rec {
  pname = "trakt-plex-sync";
  version = "0.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "trakt-plex-sync";
    rev = "7b6e4fcff1f2658fc1647e58e2e7fbfc4fcca233";
    hash = "sha256-hc/7R+1Cm4Xw2jKoYh9RdT7w01aGoW7moOQFgXih0UA=";
  };

  patches = [
    (writeText "pyproject.patch" ''
      --- a/pyproject.toml
      +++ b/pyproject.toml
      @@ -1,4 +1,5 @@
       [project]
      +version = "0.0.0"
       name = "trakt-plex-sync"
       readme = "README.md"
       authors = [{ name = "Joshua Peek" }]
    '')
  ];

  build-system = with python3Packages; [
    setuptools
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
    broken = true;
  };
}
