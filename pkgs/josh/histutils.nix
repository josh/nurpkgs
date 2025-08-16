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
    rev = "8837e55afe50d35032f6bd2b35c327f3f244147d";
    hash = "sha256-Vfbrr5h69dIjnycOQovsvQ6liRfXr+wMPGvgDC45oPE=";
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
