{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  imdb-trakt-sync = python3Packages.buildPythonApplication rec {
    pname = "imdb-trakt-sync";
    version = "0.1.0-unstable-2026-02-23";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "imdb-trakt-sync";
      rev = "4db5bb22143387a3fdedd09fea8c8059534f4c7d";
      hash = "sha256-6V412LpO5PXNL77iXaAJknrEcylxpVp9UsEtO/11EKs=";
    };

    pyproject = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      requests
    ];

    meta = {
      description = "Sync IMDb watchlist and ratings to Trakt";
      homepage = "https://github.com/josh/imdb-trakt-sync";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "imdb-trakt-sync";
    };
  };
in
imdb-trakt-sync.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    imdb-trakt-sync = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

      tests = {
        # TODO: Add --version test

        help =
          runCommand "test-imdb-trakt-sync-help"
            {
              __structuredAttrs = true;
              nativeBuildInputs = [ imdb-trakt-sync ];
            }
            ''
              imdb-trakt-sync --help
              touch $out
            '';
      };
    };
  }
)
