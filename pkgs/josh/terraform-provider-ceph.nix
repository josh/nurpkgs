{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0.0.0";
    rev = "8c2b5ad90014a85c872183dd7e27aba8fc5ef8d0";
    hash = "sha256-kZGIH7OEPCBnWFiDY6dFy2XIukuzhtDrOYo1/oldVp4=";
    vendorHash = "sha256-pl7mXrlVRD9JdVoWe8bXUhodcbF+LhhVhs6mOfuVHxE=";
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
