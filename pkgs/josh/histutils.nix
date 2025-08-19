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
    rev = "8e964edfce2148f12bd4a86a6c07780748e7e281";
    hash = "sha256-qAhTpUmTmVxnYw4a4kr6ZWQ32dSrKML2kVfTmcV7GNE=";
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
