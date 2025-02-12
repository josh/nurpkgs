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
    version = "0.1.2-unstable-2025-02-11";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "gh-audit";
      rev = "ece320d733b43dc58c455adcbae32a47e5b33b8c";
      hash = "sha256-6qLOLq/bYhoDFHxRnlrIutjLWOf+pnf6cP13r2gp1Mk=";
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
