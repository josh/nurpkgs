{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  testers,
  nix-update-script,
}:
let
  gh-audit = python3Packages.buildPythonApplication rec {
    pname = "gh-audit";
    version = "0.1.3-unstable-2026-05-01";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "gh-audit";
      rev = "007af745c48dbb53c97e878b14a4ff5c44fd8d56";
      hash = "sha256-QWummaNiVXRjMMr1mvn0HzwN34fmRmFpy5g5P2G/UN8=";
    };

    pyproject = true;
    __structuredAttrs = true;

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
  finalAttrs: previousAttrs:
  let
    gh-audit = finalAttrs.finalPackage;
    version-parts = lib.versions.splitVersion finalAttrs.version;
    stable-version = "${builtins.elemAt version-parts 0}.${builtins.elemAt version-parts 1}.${builtins.elemAt version-parts 2}";
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        version = testers.testVersion {
          package = gh-audit;
          version = stable-version;
        };

        help =
          runCommand "test-gh-audit-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ gh-audit ];
            }
            ''
              gh-audit --help
              touch $out
            '';
      };
    };
  }
)
