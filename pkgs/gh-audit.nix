{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  testers,
}:
let
  gh-audit = python3Packages.buildPythonApplication rec {
    pname = "gh-audit";
    version = "0.1.2-unstable-2025-01-17";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "gh-audit";
      rev = "427a88fdcf00d1b12f2f34dc83e862707319c177";
      hash = "sha256-lFuuVldBmELTldH7sP7FaNbVdmD4H1VvLWUj+UGvo/k=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
      click
      pygithub
      pyyaml
    ];

    meta = {
      description = "Personal GitHub repository meta linting tool for consistent configuration";
      homepage = "https://github.com/josh/gh-audit";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "gh-audit";
    };
  };
in
gh-audit.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    gh-audit = finalAttrs.finalPackage;
    version-parts = lib.versions.splitVersion finalAttrs.version;
    stable-version = "${builtins.elemAt version-parts 0}.${builtins.elemAt version-parts 1}.${builtins.elemAt version-parts 2}";
  in
  {
    passthru.updateScriptVersion = "branch";

    passthru.tests = {
      version = testers.testVersion {
        package = gh-audit;
        version = stable-version;
      };

      help =
        runCommand "test-gh-audit-help"
          {
            nativeBuildInputs = [ gh-audit ];
          }
          ''
            gh-audit --help
            touch $out
          '';
    };
  }
)
