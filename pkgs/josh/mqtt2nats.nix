{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "mqtt2nats";
  version = "0-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    rev = "184ecb2a1fbf9cc2d581bcb59e1ca52f6caaae2a";
    hash = "sha256-Co40w5nClk2rEl6FUYlHVToDr3aJ9fn/QcWGQcqmm3Q=";
  };

  vendorHash = "sha256-ffS8wJrYy3yBnyHI8qmzhZhGc/ePCTgOP5qVPZ02CVs=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Relay MQTT messages to NATS";
    homepage = "https://github.com/josh/mqtt2nats";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "mqtt2nats";
  };
}
