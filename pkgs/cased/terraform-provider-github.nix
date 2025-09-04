{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "cased";
    repo = "terraform-provider-github";
    version = "0-unstable-2025-09-04";
    rev = "7f0daa022a6939c9e5498cda21777f9210123ce3";
    hash = "sha256-KvmAY3gIv/21wedheW2AOxvlje/y9ev0oJKpekuvL38=";
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
