{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "bugjour";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "bugjour";
    rev = "32b27dd2b77d65315e3b1e3b7120568ba2a5a503";
    hash = "sha256-JreMpUm8z9rRRYJpQXVIqZoclaP+lxXHsf9C428bWZM=";
  };

  vendorHash = "sha256-4V3cIgEN8WkHHrPz9SRshoiu0C+NHR0Xov1FZ06Q9XI=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Detecting Apple Bonjour hostname conflicts…";
    homepage = "https://github.com/josh/bugjour";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "bugjour";
  };
}
