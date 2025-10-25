{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-ceph";
    rev = "v0.2.0";
    hash = "sha256-sMPRz5plbmSUAYLk6Fm2vtvM5NiXi5j9/sLnuibUGz8=";
    vendorHash = "sha256-GVd/xmKKlMAZCpyCKxojqBZmT+4RDdkvfSr4Z/6/uNk=";
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
