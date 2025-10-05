{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-05";
    rev = "8ec0aabb22ac5a6b2212fed2d06330e0e2acc6d7";
    hash = "sha256-CawxHTiz+F2YU2c4yYSeEyYFWSLmcaNzu5LF9Ce8eU4=";
    vendorHash = "sha256-qh1WsS/9C3jI6fyL06kyjLRtTBx3s8W04+tiJiSTMjM=";
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
