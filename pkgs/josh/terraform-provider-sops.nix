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
    rev = "v0.0.6";
    hash = "sha256-kM0byprw606KmsOgGn6jefhDf735b7PnkdabI+JhnnE=";
    vendorHash = "sha256-D0lDwV0rEVqUsoUh4mKKjRMr7vm56oXoRLiLfKZhviY=";
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
