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
      rev = "35328e259bfe8ff85e45af87a52b4a1a3e4989c2";
      hash = "sha256-9jOEW5BUY8BI3nfKhI6rZpn+gfd+Vv+9BlsZom431AI=";
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
