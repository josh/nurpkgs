{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-12";
    rev = "3492362d6ec27dfec809a3c5546ca7e48a82e245";
    hash = "sha256-cOCOGaTB/gcNt0g1jh2zYeLKRdiUyWObDOX7v6DO6hA=";
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
