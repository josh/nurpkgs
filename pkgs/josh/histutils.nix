{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "histutils";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MY7rnX4SMMHCrbAkQt/YEfR3La3j8vg/fagZbHvuoGE=";
  };

  cargoHash = "sha256-qefQqJmgufN+ituYISGh3W7aZd17xhhZDx/jl2X+v2U=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Import, export or merge zsh or fish history files.";
    mainProgram = "histutils";
    homepage = "https://github.com/josh/histutils";
    license = lib.licenses.mit;
  };
})
