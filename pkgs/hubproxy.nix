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
      rev = "23c25edfeecc1e96407e4291dc35fb07eaa05ad1";
      hash = "sha256-PjcbnTPa5PqjcGlcPIGMF7/g7UpCLSgK9w68fkp4DXQ=";
    };
    vendorHash = "sha256-q6Lv803D0QuACG9zN08BKTwh6AYiQow92VAWe3H5LjQ=";

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
