{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "cased";
    repo = "terraform-provider-github";
    version = "0-unstable-2025-09-04";
    rev = "ea1734e7900a4a77fa04eba811f2cf773e8cc848";
    hash = "sha256-fSIKYTnp6JB7Mf6C0D7EI2+UUA9SFNraPaLo5/J0G0A=";
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
