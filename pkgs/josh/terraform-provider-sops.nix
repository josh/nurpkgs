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
    rev = "d48df8453ea420e0337e5ba070aeafb7d8ea37a9";
    hash = "sha256-pJUFvxgIyK8DJktmJyPIa72JrStv0NNAHcAKsf+M+UQ=";
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
          "--version=branch"
          "--override-filename"
          "pkgs/josh/terraform-provider-sops.nix"
        ];
      };
    };
  }
)
