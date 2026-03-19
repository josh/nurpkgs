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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tofu-age-encryption";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N54A1iyCJ8Qtt6oMa0wHr6Zd91iW2wNuMRc1gHK4rec=";
  };

  vendorHash = "sha256-/cORC9k0BtXaChMY0jHwo3fcixeZiZaAkh0xxhGFzII=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.AgePluginPath=${lib.strings.makeBinPath finalAttrs.agePlugins}"
  ];

  agePlugins = [ age ];

  nativeCheckInputs = [
    age
    jq
    opentofu
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

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
