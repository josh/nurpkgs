{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-01";
    rev = "f4e70472662e06f1c0a66f06a14f9a500016a0f8";
    hash = "sha256-nPOWI97JKgcDJM+P9jOYPQAh0yLWPbrIimjftyPzD6Q=";
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
