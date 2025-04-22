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
    version = "1.0.0-unstable-2025-04-21";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "a45ee2f34f13457e355fc8aa253d42ee923f0da2";
      hash = "sha256-HV/PrsJe/t2Y4aCCZRLGgi9wRXpNVvRtnyDANUFPx4c=";
    };

    vendorHash = "sha256-UN1iA4GfR9lfjbIY/FD7z76cDtpaOte9svQORywOBec=";

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
