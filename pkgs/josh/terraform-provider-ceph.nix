{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-09-30";
    rev = "d01a3cd66f36ded2a7ca6c4d5f88c8a305d9b5a3";
    hash = "sha256-QabSBLMtsuo/z9tQ5DFza40kFCynXMWhzvsw0XW8Lgo=";
    vendorHash = "sha256-OxoOQSZkoCmI4xPBR8sK1l6ve31fU9HDVcGbnbUdp5k=";
    provider-source-address = "registry.terraform.io/josh/ceph";
    homepage = "https://github.com/josh/terraform-provider-ceph";
    spdx = "MIT";
  };
in
pkg.overrideAttrs (
  _finalAttrs: previousAttrs: {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version=branch"
          "--override-filename"
          "pkgs/josh/terraform-provider-ceph.nix"
        ];
      };
    };
  }
)
