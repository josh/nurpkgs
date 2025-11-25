{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  imdb-plex-sync = python3Packages.buildPythonApplication {
    pname = "imdb-plex-sync";
    version = "0.1.1-unstable-2025-11-24";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "d8d5af8a75b200b2d60b6513861590b316d421c1";
      hash = "sha256-DJSMnxrgWeRReiaySq0MDmUVbYAcX9oSRq6RBp2zJE8=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      polars
    ];

    meta = {
      description = "Sync IMDb watchlist to Plex watchlist";
      homepage = "https://github.com/josh/imdb-plex-sync";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "imdb-plex-sync";
    };
  };
in
imdb-plex-sync.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    imdb-plex-sync = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        help =
          runCommand "test-imdb-plex-sync-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ imdb-plex-sync ];
            }
            ''
              imdb-plex-sync --help
              touch $out
            '';
      };
    };
  }
)
