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
    version = "0-unstable-2025-02-09";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "b3c20801927c947e96b243408e65a9c3df31a1a5";
      hash = "sha256-r7rf/n5wBTxVp2DczK8wXy3FO1qWSnIW1qfaHITcX+A=";
    };
    vendorHash = "sha256-nPS9quniXYKCqOFMqnDKxCjzFNUZnkNc7mqnSqP2g9c=";

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
            nativeBuildInputs = [ hubproxy ];
          }
          ''
            hubproxy --help
            touch $out
          '';
    };
  }
)
