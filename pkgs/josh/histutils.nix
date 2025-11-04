{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "histutils";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-owa1T+gg/xm86pgZPvTnkQLnxhLRxlEgmxfyunQGthg=";
  };

  cargoHash = "sha256-Ehsb+teh2AmygBo93aPgmL8cQD4i17Ov1oOwvptP3GA=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Import, export or merge zsh or fish history files.";
    mainProgram = "histutils";
    homepage = "https://github.com/josh/histutils";
    license = lib.licenses.mit;
  };
})
