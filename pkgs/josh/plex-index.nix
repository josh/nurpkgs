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
    version = "0-unstable-2025-09-12";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "plex-index";
      rev = "481d11b1b039e481b6207e81c2be5ca221bc8aba";
      hash = "sha256-JT7asyDaKCWClVbsZGxvQH7O0zzUd/sYIg6tHs0rijw=";
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
