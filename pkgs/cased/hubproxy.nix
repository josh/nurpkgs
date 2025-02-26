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
    version = "0-unstable-2025-02-26";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "efebdb3a44f30edbc1846e56e032d7cbe79609f5";
      hash = "sha256-Rws6Jkv2lnaRRyYMy8x+IbtsItK1RBC4OuVRIl2YvQo=";
    };

    vendorHash = "sha256-q6Lv803D0QuACG9zN08BKTwh6AYiQow92VAWe3H5LjQ=";

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
