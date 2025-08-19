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
    rev = "5ab6ff33b0efae9a9ded7a204cc6b3b36c234968";
    hash = "sha256-LZClW6xz+NS9MdOSgK1vt0rCovIGegBUJ3PbbHGj7TI=";
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
