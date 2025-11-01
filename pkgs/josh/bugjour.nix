{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "bugjour";
  version = "0-unstable-2025-11-01";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "bugjour";
    rev = "e1327f7967b85663c273493a9df8b137c58a852b";
    hash = "sha256-LIZgaaX09e2d58QK2fgJ0crxEBCQYneOY0WzYd3g5Mw=";
  };

  vendorHash = "sha256-4V3cIgEN8WkHHrPz9SRshoiu0C+NHR0Xov1FZ06Q9XI=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Detecting Apple Bonjour hostname conflicts…";
    homepage = "https://github.com/josh/bugjour";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "bugjour";
  };
}
