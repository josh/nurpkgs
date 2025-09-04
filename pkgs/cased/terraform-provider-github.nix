{ terraform-providers, nix-update-script }:
let
  pkg = terraform-providers.mkProvider {
    owner = "cased";
    repo = "terraform-provider-github";
    rev = "9826ea55be7b673c0f3d8513f3ba5ae097b91916";
    hash = "sha256-ITnpR4JMWrkFjfxEK62TgujXHVL7kiA8J5ziytAeTAQ=";
    vendorHash = null;
    provider-source-address = "registry.terraform.io/cased/github";
    homepage = "https://github.com/cased/terraform-provider-github";
    spdx = "MIT";
  };
in
pkg
// {
  updateScript = null;
  passthru = pkg.passthru // {
    # updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    updateScript = null;
  };
  meta = pkg.meta // {
    position = "${./terraform-provider-github.nix}:17";
  };
}
