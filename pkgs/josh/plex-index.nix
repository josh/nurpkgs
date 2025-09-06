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
    version = "0-unstable-2025-09-06";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "plex-index";
      rev = "40e0c26fa86d2e2c1d9dcb127b0b01c872931a74";
      hash = "sha256-J89Ef5qXaOkAhBSVFa/4RxXrSodZtwfYBsTpbTBgeEg=";
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
      # FIXME: Broken on nixos-25.05
      broken = python3Packages.polars.version == "1.27.1";
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
