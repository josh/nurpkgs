# See <https://github.com/josh/gh-audit/blob/main/package.nix>
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "gh-audit";
  version = "0-unstable-2024-12-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gh-audit";
    rev = "2c4e59b4815fd21b5ae8d5fc5bd4094d863014f5";
    hash = "sha256-RbnSYEhzQoLLD7/1ZSCLVSzW2KeLkWuQ35gVQnaX510=";
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
