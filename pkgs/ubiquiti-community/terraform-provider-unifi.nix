{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "ubiquiti-community";
    repo = "terraform-provider-unifi";
    rev = "v0.41.12";
    hash = "sha256-KqS7WqXDvXyljuJI8+1gJbSayMnfN2AlioJS9WZZQRA=";
    vendorHash = "sha256-l6EzevVL6YxLLq9QWcGZv9Go+0sUToLubHbMeNL1vJg=";
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
