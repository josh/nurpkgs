{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  skyline = python3Packages.buildPythonApplication rec {
    pname = "skyline";
    version = "0-unstable-2025-02-03";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "skyline";
      rev = "d30f51d6e64abea50aad26ad3d8e021c1156e245";
      hash = "sha256-UybG20V15ry+WhX7N3Cj9dMH0f+mfCVENqHAb2BACwM=";
    };

    pyproject = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [
      hatchling
    ];

    dependencies = with python3Packages; [
      click
      flask
      requests
      rich
      sseclient-py
    ];

    meta = {
      description = "The missing automation for creating GitHub Apps";
      homepage = "https://github.com/cased/skyline";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "skyline";
    };
  };
in
skyline.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    skyline = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "branch";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      help =
        runCommand "test-skyline-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ skyline ];
          }
          ''
            skyline --help
            touch $out
          '';
    };
  }
)
