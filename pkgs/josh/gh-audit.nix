{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  gh-audit = python3Packages.buildPythonApplication {
    pname = "gh-audit";
    version = "0-unstable-2026-05-08";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "gh-audit";
      rev = "4dda81881a6246360d4abc9ff35068f6043b41f9";
      hash = "sha256-VuOEas7ESG8jjmX3tRne+wL5AeSzJqxRsjR19lzND6I=";
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
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
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
