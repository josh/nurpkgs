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
      rev = "62e0e24a1809d4908d05a7413d50e6a7d0afd6a9";
      hash = "sha256-FfBHPkcVOARnBoIFQKdIAQqUoajS8DZ/DSvBv/3xYr8=";
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
