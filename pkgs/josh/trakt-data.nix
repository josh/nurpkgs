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
    version = "0-unstable-2025-05-05";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-data";
      rev = "118230abde953f30dfaa6fc9c5856f633ab2de28";
      hash = "sha256-zPWlqQ2PYsf226F9I/iUWULM2kyFOtGPNnFV+UexjA0=";
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
