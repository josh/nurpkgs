{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-08";
    rev = "1044ee656fd398ad779984b6608532dbe9a85413";
    hash = "sha256-Cbc+k8DAxMGI+uAVi9sIBhzuGQnBRFtlObYdk2KL324=";
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
