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
    version = "0-unstable-2025-04-18";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "0db64f2dc7813c851510f57c4901655d7799d8bc";
      hash = "sha256-RvJMiwwIxRLFmzZpnPyB9Ejtip4dIjk9qY5TBnYGY+g=";
    };

    vendorHash = "sha256-8l6mjvePyrNHbQ76zPlPWF6STN8PKGWH9UfTQ4CauIA=";

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
