{ terraform-providers, nix-update-script }:
(terraform-providers.mkProvider {
  owner = "cased";
  repo = "terraform-provider-github";
  rev = "9826ea55be7b673c0f3d8513f3ba5ae097b91916";
  hash = "sha256-ITnpR4JMWrkFjfxEK62TgujXHVL7kiA8J5ziytAeTAQ=";
  vendorHash = null;
  provider-source-address = "registry.terraform.io/cased/github";
  homepage = "https://github.com/cased/terraform-provider-github";
  spdx = "MIT";
}).overrideAttrs
  (
    _finalAttrs: previousAttrs: {
      passthru = previousAttrs.passthru // {
        updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
      };
    }
  )
