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
      rev = "56b1ead9a392ba373ee8ae5be61920da4438e58c";
      hash = "sha256-vskDUAS1kIyJ0afziI+9mQBgaKxpMR36o1SVvtmN0sI=";
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
