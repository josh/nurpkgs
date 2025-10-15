{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-15";
    rev = "55205a2f7b02c2431e6c54c457890dbf1c8a0eb2";
    hash = "sha256-2BFXzV+8JpK5ZQbRUf3OjvmZFRKKThskKHBjL+99hac=";
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
