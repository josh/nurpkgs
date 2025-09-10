{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "bugjour";
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "bugjour";
    rev = "64d284c95e20c3fe98160086ff1b06c5051d8e45";
    hash = "sha256-1uu7N9KyvEcFYsmjDcau0JlAWi6XhQxHNnoH+U8oyFs=";
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
