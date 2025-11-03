{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "histutils";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ekfoNWVII+RsUBdwb8+QXTvM5Gp5TPXOKyVO8tmfyKY=";
  };

  cargoHash = "sha256-KikvIdkingUPqcxY5tLmWoWhhDsleDtF+kM3dDhYwZQ=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Import, export or merge zsh or fish history files.";
    mainProgram = "histutils";
    homepage = "https://github.com/josh/histutils";
    license = lib.licenses.mit;
  };
})
