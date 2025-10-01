{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "bugjour";
  version = "0-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "bugjour";
    rev = "0048495c2603645ea83e0552026b2ed07cb02cc4";
    hash = "sha256-hYsLx71FE7TgnADIgW4uwpnVLEhWH/sf0cx6vkvj9Rc=";
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
