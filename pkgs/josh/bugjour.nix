{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "bugjour";
  version = "0-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "bugjour";
    rev = "f78cdd9ef8f0150781dc8eb6acffd31009266ed7";
    hash = "sha256-1VuJAMoinUOxW1K4UYfxh+SIwY70SSwITposuvIxQVA=";
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
