{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0.1.0-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "8d47cb4dc7bc5402fc47f5663dcf614e4d1ca4a7";
    hash = "sha256-yIlkDhI3XCjX3rINX/Cp8QIN1XEOV9iAXqm1ct1173I=";
  };

  cargoHash = "sha256-qefQqJmgufN+ituYISGh3W7aZd17xhhZDx/jl2X+v2U=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Import, export or merge zsh or fish history files.";
    mainProgram = "histutils";
    homepage = "https://github.com/josh/histutils";
    license = lib.licenses.mit;
  };
}
