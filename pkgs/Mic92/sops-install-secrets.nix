{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "sops-install-secrets";
  version = "assets-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "d5abe5e53200ad48254e8e6bd95e6cef94e66577";
    hash = "sha256-2p8/wnENYHU2Z79Ir/rpq+V1sMI9mSD6xGAlvlbVBUY=";
  };

  vendorHash = "sha256-5cItEpjESOn7kd9el/zGVx5BlNSaO/ebwuO2le4iuHs=";

  subPackages = [ "pkgs/sops-install-secrets" ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=master" ];
  };

  passthru.tests = {
    check-empty-manifest =
      runCommand "test-sops-install-secrets-check-empty-manifest"
        { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          echo '{}' >manifest.json
          sops-install-secrets -check-mode=manifest manifest.json
          sops-install-secrets -check-mode=sopsfile manifest.json
          touch $out
        '';
  };

  meta = {
    description = "Atomic secret provisioning based on sops";
    homepage = "https://github.com/Mic92/sops-nix";
    license = lib.licenses.mit;
    mainProgram = "sops-install-secrets";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
