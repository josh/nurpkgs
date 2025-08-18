{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "50aa8a85ccafd742bdf801cad0dc6bdf6465fe2f";
    hash = "sha256-Kbm63jzXK23/46qCR/f1kjT36T64o6OrlQFIVNh07dg=";
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
