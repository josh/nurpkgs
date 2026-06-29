{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "Telmate";
    repo = "terraform-provider-proxmox";
    rev = "v3.0.2-rc07";
    hash = "sha256-38q64EwxcdFzmlkL/jA0bTAF0WKXHEBIO0yS/44PizA=";
    vendorHash = "sha256-ZuH+uIv+iRQgUooyXsryICItSRglk1AGGWMVb+o1ILs=";
    provider-source-address = "registry.terraform.io/Telmate/proxmox";
    homepage = "https://github.com/Telmate/terraform-provider-proxmox";
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
          "pkgs/Telmate/terraform-provider-proxmox.nix"
        ];
      };
    };
  }
)
