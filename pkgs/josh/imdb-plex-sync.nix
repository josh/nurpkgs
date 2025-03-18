{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  imdb-plex-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-plex-sync";
    version = "0.1.0-unstable-2025-03-17";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "533286bd9d52f3ff1e287a1d55a15ce601248dc6";
      hash = "sha256-HXjp6TigdQ2ak808xP248lU7o6pwXkSoat9OkjthP1g=";
    };

    pyproject = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      plexapi
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
  finalAttrs: _previousAttrs:
  let
    imdb-plex-sync = finalAttrs.finalPackage;
  in
  {
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      # TODO: Add --version test

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
  }
)
