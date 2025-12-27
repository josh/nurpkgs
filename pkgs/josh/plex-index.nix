{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  plex-index = python3Packages.buildPythonApplication {
    pname = "plex-index";
    version = "0-unstable-2025-12-22";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "plex-index";
      rev = "66a6260fd1e90dee7be185e66a1b08734d6e48ff";
      hash = "sha256-bBSCdScuR4ZxV/tTN6i0VC2sKZIWlqv0HdguaBZ4a3Y=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      polars
      tqdm
    ];

    meta = {
      description = "Compact Plex external ID index";
      homepage = "https://github.com/josh/plex-index";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "plex-index";
      broken = lib.strings.versionOlder python3Packages.polars.version "1.30";
    };
  };
in
plex-index.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    plex-index = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        help =
          runCommand "test-plex-index-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ plex-index ];
            }
            ''
              plex-index --help
              touch $out
            '';
      };
    };
  }
)
