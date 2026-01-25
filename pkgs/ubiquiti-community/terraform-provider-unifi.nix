{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-unifi";
    rev = "v0.41.3";
    hash = "sha256-IqsQRVgAB1PUqYJ0JPig6oq7FKJuS/a2NCgTCxX9+cg=";
    vendorHash = "sha256-iqwdSzyVZE5CitzXc8rWn2zO3v+VvuDNeS0ll0V6MtU=";
    provider-source-address = "registry.terraform.io/ubiquiti-community/unifi";
    homepage = "https://github.com/ubiquiti-community/terraform-provider-unifi";
    spdx = "MPL-2.0";
  };
in
pkg.overrideAttrs (
  _finalAttrs: previousAttrs: {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version=stable"
          "--override-filename"
          "pkgs/ubiquiti-community/terraform-provider-unifi.nix"
        ];
      };
    };
  }
)
