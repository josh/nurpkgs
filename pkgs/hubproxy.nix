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
      rev = "fe2c4bb9fbd21863f6b4827ac4e30012f9aac484";
      hash = "sha256-2PBzi5CvERhp1joDy9ZXsqWcu0M/7Pb088ZF7d00EEo=";
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
