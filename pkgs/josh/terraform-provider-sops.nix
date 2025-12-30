{
  lib,
  terraform-providers,
  sops,
  nix-update-script,
}:
let
  pkg = terraform-providers.mkProvider {
    owner = "josh";
    repo = "terraform-provider-sops";
    rev = "v0.0.1";
    hash = "sha256-G4bdi9TS8BVUh0Y1yB275t5rS65h1L9NcS9T/Q7sCG8=";
    vendorHash = "sha256-UQMko8XfGXbAntXlJ2yUwg0XEgWaZ747atp5XRs9Mb8=";
    provider-source-address = "registry.terraform.io/josh/sops";
    homepage = "https://github.com/josh/terraform-provider-sops";
    spdx = "MIT";
  };
in
pkg.overrideAttrs (
  _finalAttrs: previousAttrs: {
    ldflags = previousAttrs.ldflags ++ [ "-X main.sopsBinary=${lib.getExe sops}" ];
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version=stable"
          "--override-filename"
          "pkgs/josh/terraform-provider-sops.nix"
        ];
      };
    };
  }
)
