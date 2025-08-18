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
    rev = "a076a116beeaa995084e4861c5c71ec44c70a70e";
    hash = "sha256-Q9R3rUM2lN8ljswPf3sRPq54IYgwqJMqFmJDVppYLGg=";
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
