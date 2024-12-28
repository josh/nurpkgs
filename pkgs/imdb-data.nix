{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "imdb-data";
  version = "0.1.0-unstable-2024-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "imdb-data";
    rev = "435eb2ac17846f7b73bfc235c123b8288c69cb93";
    hash = "sha256-CfCzASkGu2zQonsvUdTby9cYXAI1O3v7bGe+sC95vls=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    parsel
    requests
  ];

  passthru.updateScriptVersion = "branch";

  meta = {
    description = "IMDB personal lists and ratings data scaper";
    homepage = "https://github.com/josh/imdb-data";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "imdb-data";
  };
}
