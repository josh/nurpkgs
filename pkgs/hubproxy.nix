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
    version = "0-unstable-2025-02-15";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "4aa9de5ff51fa6cb7e41f3e08926ba3054d9afdc";
      hash = "sha256-pPSTKPxY3hqs7XaT5eqXmVf3GcNKMKk5IyC5tANV5k0=";
    };
    vendorHash = "sha256-m/jFGyGRyytc+iTpRVIBr5Fn6G7pWWS9cPoNSG7fOYo=";

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
