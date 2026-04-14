{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  trakt-data = python3Packages.buildPythonApplication {
    pname = "trakt-data";
    version = "0-unstable-2026-04-14";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-data";
      rev = "c2e0d575b3c79bd2b4e39be8a299ffafae43ec99";
      hash = "sha256-sm4NTQSNSudI00z0xZSJGgJqGWtYA6RIQyMUD1oVKuk=";
    };

    pyproject = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      prometheus-client
      requests
    ];

    meta = {
      description = "Export Trakt data";
      homepage = "https://github.com/josh/trakt-data";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "trakt-data";
    };
  };
in
trakt-data.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    trakt-data = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        # TODO: Add --version test

        help =
          runCommand "test-trakt-data-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ trakt-data ];
            }
            ''
              trakt-data --help
              touch $out
            '';
      };
    };
  }
)
