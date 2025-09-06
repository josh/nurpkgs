{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  age,
  opentofu,
}:
buildGoModule (finalAttrs: {
  pname = "tofu-age-encryption";
  version = "0-unstable-2025-09-06";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tofu-age-encryption";
    rev = "2eccc7f616208c42babea68d5d5d4a1f16d778bc";
    hash = "sha256-rK4+lklG840yKIdNKG9vQ4JDh8CAaMCJoO+2eLB91cQ=";
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
