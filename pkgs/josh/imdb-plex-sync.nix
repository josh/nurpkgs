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
    version = "0.1.1-unstable-2025-06-02";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-plex-sync";
      rev = "b0d4826f12496e5059fff09263ca2c41255a2d7a";
      hash = "sha256-gsjM7Ul2TxLkVztHFJxPmW8KWpn7IsZoYoZe8ID7i+E=";
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
  finalAttrs: previousAttrs:
  let
    imdb-plex-sync = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
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
    };
  }
)
