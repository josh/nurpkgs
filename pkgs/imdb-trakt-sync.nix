{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "imdb-trakt-sync";
  version = "0.1.0-unstable-2024-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "imdb-trakt-sync";
    rev = "0ade58e96330056708a078714ac4379e30c2ab61";
    hash = "sha256-YMr+VeoqmDGtfncqu18JqwJ0+j3VUlIJW32GVdjyvqk=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    requests
  ];

  passthru.updateScriptVersion = "branch";

  meta = {
    description = "Sync IMDb watchlist and ratings to Trakt";
    homepage = "https://github.com/josh/imdb-trakt-sync";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "imdb-trakt-sync";
  };
}
