{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0-unstable-2025-08-17";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "63f2dfeb815bbe94fc3fdb5812b5311c444935e3";
    hash = "sha256-jtlgXzHl9SsV98Y7mi8FpBZnSTvbdZgBKTA4Tu4RTx0=";
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
