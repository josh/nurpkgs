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
    version = "0-unstable-2025-03-07";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "edcb786f96101526d4d7dd52dce9f0e04bca0687";
      hash = "sha256-7yVl3osHELrjr5qxIWstYsB6bogjvOOg1KF4gymSqPs=";
    };

    vendorHash = "sha256-GoL6e+TDFNYzJntw4dV3YJKKyWsQIjqmLUGon135rDQ=";

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
