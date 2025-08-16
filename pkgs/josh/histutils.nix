{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "histutils";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "histutils";
    rev = "aaef37888ddc501cc3c5977beedb8f3c2e2f937e";
    hash = "sha256-p2w2RHdvQSK3faCSBwrXTQmJzALwPzdoDGH7sknPxs8=";
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
