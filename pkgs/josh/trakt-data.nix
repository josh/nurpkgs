{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  trakt-data = python3Packages.buildPythonApplication rec {
    pname = "trakt-data";
    version = "0-unstable-2025-05-12";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-data";
      rev = "c137f60375db22988d79c33eb8008de9dde08ce9";
      hash = "sha256-VAwOos20X07gwTm0wpoXLr54M5eur8/AGAU57AIWCAY=";
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
  finalAttrs: _previousAttrs:
  let
    trakt-data = finalAttrs.finalPackage;
  in
  {
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
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
  }
)
