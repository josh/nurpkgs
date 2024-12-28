{
  lib,
  fetchFromGitHub,
  writeText,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "imdb-plex-sync";
  version = "0-unstable-2024-12-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "imdb-plex-sync";
    rev = "c78cc9a959b3fef448f2a7462cb22783bf4a3c37";
    hash = "sha256-M1D08jrNsRC+4l1quw7x9m0zqI/xl90rA0b0iCWvlg4=";
  };

  patches = [
    (writeText "pyproject.patch" ''
      --- a/pyproject.toml
      +++ b/pyproject.toml
      @@ -1,4 +1,5 @@
       [project]
      +version = "0.0.0"
       name = "imdb-plex-sync"
       readme = "README.md"
       authors = [{ name = "Joshua Peek" }]
    '')
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    plexapi
  ];

  passthru.updateScriptVersion = "branch";

  meta = {
    description = "Sync IMDb watchlist to Plex watchlist";
    homepage = "https://github.com/josh/imdb-plex-sync";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "imdb-plex-sync";
  };
}
