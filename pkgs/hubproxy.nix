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
    version = "0-unstable-2025-02-06";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "c2b11c2c42721433541f9cedbd2e106fdbe79347";
      hash = "sha256-2WC8wcW74cVMaEJCQlO8zBu0V9fiv39GZxGMENtyE7M=";
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
