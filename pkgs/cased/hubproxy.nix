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
    version = "0-unstable-2025-03-09";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "cfb19495fe6e5dc2400a15ac920bf9848956b061";
      hash = "sha256-Gs69AlAGUGT8D+blqLWlQtMaOgQB2YopXzSy4mURQ/c=";
    };

    vendorHash = "sha256-B1y0u4/RdrgkmWYg/LhDz6R9OxyqQ7ij5FzMbezmJWs=";

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
