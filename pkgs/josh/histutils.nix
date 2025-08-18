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
    rev = "eeec7b47d14655189084ad70a1aebb29d18b53e2";
    hash = "sha256-fA8ZvWekpHF/Q/MGxxBRvAfzFmUMoqmobEp0Hu7SLVI=";
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
