{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    version = "0-unstable-2025-10-14";
    rev = "13e6665950f0fedb99ae98dfff8bb2f53a50158a";
    hash = "sha256-DE78GANQkeY0fRr+qRjrYF0FEsPfyK60B6e7I/pgKHI=";
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
