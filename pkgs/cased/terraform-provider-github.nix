{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "cased";
    repo = "terraform-provider-github";
    version = "0-unstable-2025-09-04";
    rev = "a333f2314471cb41cf6244b6f79b0c6b19e92fe4";
    hash = "sha256-IRdx0iWBYvX6+qLmulAPD+Z4nZ5Pus2fSqO29QvHL0o=";
    vendorHash = null;
    provider-source-address = "registry.terraform.io/cased/github";
    homepage = "https://github.com/cased/terraform-provider-github";
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
          "pkgs/cased/terraform-provider-github.nix"
        ];
      };
    };
  }
)
