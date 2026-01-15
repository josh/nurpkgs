{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    rev = "v0.5.0";
    hash = "sha256-a2wVKA1Hg1hMjSJbAjQBfxqbiJy2PX3V6htLlOGaTEk=";
    vendorHash = "sha256-gBvHxWbm+CvcowfcqUxOZa9afxh9hgcDcJElC9qc5Ek=";
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
          "--version=stable"
          "--override-filename"
          "pkgs/josh/terraform-provider-ceph.nix"
        ];
      };
    };
  }
)
