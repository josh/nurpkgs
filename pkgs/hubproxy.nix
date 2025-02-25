{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
let
  hubproxy = buildGoModule rec {
    pname = "hubproxy";
    version = "0-unstable-2025-02-25";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "2dc706518f861b50b4985f42db7fa7a8115fe458";
      hash = "sha256-3wGPLjYfvFHWFBRgpVgXfEPquO8OdJOtDwdalzRfAOY=";
    };
    vendorHash = "sha256-q6Lv803D0QuACG9zN08BKTwh6AYiQow92VAWe3H5LjQ=";

    meta = {
      description = "A proxy for better github webhooks";
      mainProgram = "hubproxy";
      homepage = "https://github.com/cased/hubproxy";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  };
in
hubproxy.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    hubproxy = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "branch";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      help =
        runCommand "test-hubproxy-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ hubproxy ];
          }
          ''
            hubproxy --help
            touch $out
          '';
    };
  }
)
