{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-sops";
    rev = "07832a1b4cd7dbf779bfbab208c95abf67a8e092";
    hash = "sha256-koKvupFiXUOfhdg0rN8cZb5L3rvXIVWO5fdZS1RUyao=";
    vendorHash = "sha256-UQMko8XfGXbAntXlJ2yUwg0XEgWaZ747atp5XRs9Mb8=";
    provider-source-address = "registry.terraform.io/josh/sops";
    homepage = "https://github.com/josh/terraform-provider-sops";
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
          "pkgs/josh/terraform-provider-sops.nix"
        ];
      };
    };
  }
)
