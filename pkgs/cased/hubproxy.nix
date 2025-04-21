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
      rev = "7d5426607f0d0ab074b1ed9dd71d3c96ed80bc59";
      hash = "sha256-YWntEL14xrOe7a0LIWzpuQXWg9kTd2gb7yqBAohgeSo=";
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
