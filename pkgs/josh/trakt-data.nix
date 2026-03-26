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
    version = "0-unstable-2026-03-26";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-data";
      rev = "3266176982861fa8dcc2c00c7dec009865fb8970";
      hash = "sha256-W+sMDsH89GHi6N79p2DoiY+utMdHmiQHgICjEF4eOXw=";
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
