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
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tofu-age-encryption";
    rev = "c753b339d68a66bd729d5ee3bd6b5b1258ae119d";
    hash = "sha256-+WTGuq/HsCTH0DzxSZ9wQAY+qiIrRtoStuQG3ITcYyU=";
  };

  vendorHash = "sha256-OEXvKQ/dBxhz6/pbQNDYIjBf3O0x36ZE3Se/FqEgYRg=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.AgeProgram=${lib.getExe age}"
  ];

  # TODO: Fix running go tests in nix sandbox
  doCheck = false;

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
  };
})
