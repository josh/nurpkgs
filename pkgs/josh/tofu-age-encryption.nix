{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  age,
  jq,
  opentofu,
}:
buildGoModule (finalAttrs: {
  pname = "tofu-age-encryption";
  version = "1.0.0-unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tofu-age-encryption";
    rev = "01ff2a02c70cfbfe22ddb18674ec6f5eaa879911";
    hash = "sha256-XGPHzKwi3xERmW0EWUPo0+7FCCtDlmd5iyfaiUEwvaE=";
  };

  vendorHash = "sha256-OEXvKQ/dBxhz6/pbQNDYIjBf3O0x36ZE3Se/FqEgYRg=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.AgeProgram=${lib.getExe age}"
  ];

  nativeCheckInputs = [
    age
    jq
    opentofu
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests =
    let
      tofu-age-encryption = finalAttrs.finalPackage;
    in
    {
      version = testers.testVersion {
        package = tofu-age-encryption;
        inherit (finalAttrs) version;
      };
    };

  meta = {
    description = "Encrypt OpenTofu state data with age encryption keys";
    homepage = "https://github.com/josh/tofu-age-encryption";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "tofu-age-encryption";
    broken = lib.strings.versionOlder opentofu.version "1.10.0";
  };
})
