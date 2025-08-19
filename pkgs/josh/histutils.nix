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
    rev = "a586452742ffac5acfcd92ccbeab26b488651ed5";
    hash = "sha256-Nm5LewdKvn+Nbtaka6CuDHptcA4SDr5ZQc0qWbgKN9A=";
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
