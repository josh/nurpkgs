{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-09-30";
    rev = "3e36e5f8db07c600944d943e9a1c914a02bfd5c5";
    hash = "sha256-rN9l7/VuypAdCbD8PjIj0RWa7rULdNuAZx1aD7Ollrs=";
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
