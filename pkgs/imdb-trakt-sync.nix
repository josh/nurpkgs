{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "imdb-trakt-sync";
  version = "0-unstable-2024-12-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "imdb-trakt-sync";
    rev = "971ee6838a775f0bc5028e511ff3b398296ecbcb";
    hash = "sha256-vOn3TJ+5BeJC5semktGjYatv5RKwqCI3F1sKrb930Yw=";
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
