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
    rev = "3097e131e1db931763317f55677a0c24d0d2a32b";
    hash = "sha256-9hk/r7MOe3LFlAJIofByMb9Jx7Lgw0K1AxThmpvpGeY=";
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
