{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "4d4740aa9317709b82c94ff4b8048537bb45cf80";
    hash = "sha256-ZZDC0jo/2QupJA8QpqHuAYrGZ9NXOT9ab4gVwblmEPs=";
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
