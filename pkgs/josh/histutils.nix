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
    rev = "3368683e1ce6938799d8788d7b8a1381ce676f81";
    hash = "sha256-ZZB8vsC3iUo24c5xFPjQSGBXFlq2sphkMOotoMqhomM=";
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
