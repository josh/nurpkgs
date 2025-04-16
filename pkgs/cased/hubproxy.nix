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
    version = "0-unstable-2025-04-15";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "28b2ce065178770fedc8067d9ad3a1520f85221c";
      hash = "sha256-tRNUcdn92RQzNu0PfwKqQONtJ0WCSaDjM0zd/WnPYVQ=";
    };

    vendorHash = "sha256-4mWu1OP1YxqeGNnjRe9W+T63ZAIh+p7xX7ICx5bAW0M=";

    meta = {
      description = "A proxy for better github webhooks";
      homepage = "https://github.com/cased/hubproxy";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "hubproxy";
    };
  };
in
hubproxy.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    hubproxy = finalAttrs.finalPackage;
  in
  {
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
