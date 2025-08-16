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
    rev = "d05e5f453fbbeb19713aafc4c87a7f3c25c24bdc";
    hash = "sha256-OBqYcLMLc1GKuslD2y/DY9tt/WA8mgYtJTejiKtjwMg=";
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
