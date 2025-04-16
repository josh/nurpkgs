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
    version = "0-unstable-2025-04-16";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "fdf633ab493f7e8478b4f5e740b11091f7e935b6";
      hash = "sha256-Kzj+4SGDpADwBL9SBOT1Kmu8aagRzPBB1fsSgI7jpyQ=";
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
