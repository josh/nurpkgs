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
    version = "0-unstable-2025-04-10";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "trakt-data";
      rev = "155caa04e6d2450c6613ff82fba00eff774f0beb";
      hash = "sha256-lx4uRf2NFmljmH8mUToNMT2tatGOub4LngIkfuoRENQ=";
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
