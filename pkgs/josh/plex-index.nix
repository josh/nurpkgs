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
    version = "0-unstable-2025-12-01";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "plex-index";
      rev = "c4aabbea41487e4bf58efbf5d62a2f084c7acca2";
      hash = "sha256-W62BQh0v3W3pp58KQUooKWYPeZGKOAmeC3SAET/BVzo=";
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
