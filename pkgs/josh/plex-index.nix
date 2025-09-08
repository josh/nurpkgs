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
    version = "0-unstable-2025-09-08";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "plex-index";
      rev = "ca3d85308d500b7d46942987e8f5c4c26b3c3697";
      hash = "sha256-OEt2bquWK+pHMV8+7AmW7pBtvPaSmxs7PBshMXoB7HY=";
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
