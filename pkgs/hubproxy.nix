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
    version = "0-unstable-2025-02-11";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "2f4d07ca672bf46f8722853afac42b6b65a92411";
      hash = "sha256-5uJANNvhgSpkO3CywcAif2kzgtrQwHiPX+4Z9x0iJ/A=";
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
