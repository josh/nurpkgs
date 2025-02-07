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
    version = "0-unstable-2025-02-07";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "eae2e932f815448a13a1b536e62b9472103d9ca4";
      hash = "sha256-ZTPqo4aY7sQHZhWqWtfHWircc7wgjiYt3rpqjjY93xU=";
    };
    vendorHash = "sha256-g9uqDESN65+juVXMsEzKJQzdlNkSzSDmGceaVXNwAhA=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $GOPATH/bin/proxy $out/bin/hubproxy

      runHook postInstall
    '';

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
            nativeBuildInputs = [ hubproxy ];
          }
          ''
            hubproxy --help
            touch $out
          '';
    };
  }
)
