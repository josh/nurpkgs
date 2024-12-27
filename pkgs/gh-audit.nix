# See <https://github.com/josh/gh-audit/blob/main/package.nix>
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "gh-audit";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gh-audit";
    rev = "8238eba83e5f46302b7c6c9becb2b0f32d4fa4d3";
    hash = "sha256-m7TzEImaW6n6RhWNO1i8KtsUUiKyX3hUJHQ2rKu3Y3A=";
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
