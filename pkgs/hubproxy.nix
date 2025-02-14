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
    version = "0-unstable-2025-02-14";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "40e93f806fa8ed2362fb044289843570161352e7";
      hash = "sha256-dKuuRwf+X4ZcZ6HqvMHPlFQ7xHqokdcOyy/I9pgLGoQ=";
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
