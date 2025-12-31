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
    rev = "v0.0.4";
    hash = "sha256-xqCsgXZaY7HGiiK7gfeS1BDF5Gdm4D1+WTBFMCccFHk=";
    vendorHash = "sha256-brfiJ6e8tJ2AKHbXA9E0z9UgP77xPJlYa7196jf0Bpc=";
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
