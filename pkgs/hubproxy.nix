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
    version = "0-unstable-2025-02-20";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "37579503ca423e20fb85bd3bc3afb948259efdcf";
      hash = "sha256-FQyEtF4XiA0ZgmaXVjLxC7ZVx/53/TTHUHZFcYYmjoU=";
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
