{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0-unstable-2025-08-16";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "3861f0bfc9a9b2540cbe190333a3460e0d1cf747";
    hash = "sha256-FevXr3aJaYc9Vjzif7SlZ4cKc5LSh7lJvFF1ppzTKU8=";
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
