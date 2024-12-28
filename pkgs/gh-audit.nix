{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "gh-audit";
  version = "0.1.1-unstable-2024-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gh-audit";
    rev = "52f4a23541cd7163a3cfbed4e7753b38b5df1fb7";
    hash = "sha256-+WT7Agg8+NBiJfry43F03o7gcJsQnGVqVwyvyLNHtIE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    pygithub
    pyyaml
  ];

  passthru.updateScriptVersion = "branch";

  meta = {
    description = "Personal GitHub repository meta linting tool for consistent configuration";
    homepage = "https://github.com/josh/gh-audit";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "gh-audit";
  };
}
