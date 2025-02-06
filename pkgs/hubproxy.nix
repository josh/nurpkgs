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
    version = "0.0.0";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "hubproxy";
      rev = "94d6484fd679d5d25587d1e311cef6ea71dc80fb";
      hash = "sha256-GXzWvYM5rXH5I7+xYESU9z50dAvNaKVtSuhNj1LYQM0=";
    };
    vendorHash = "sha256-ia57cSe3pXzK7kh0Vj7vUD5xtvXnDchVGWV+Iklsk8M=";

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
