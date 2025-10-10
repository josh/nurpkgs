{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-09";
    rev = "8edc82c111e9ffff756d0cd405cf7b92c55bb40b";
    hash = "sha256-SIqejKZ5lVbn6CX6p2lZDTVHqzx/MbcjJNRIBt8NHqM=";
    vendorHash = "sha256-I28FnUbD05GDWii8VTuQfwvF9nrCv/3QRnXqa+WuQmY=";
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
