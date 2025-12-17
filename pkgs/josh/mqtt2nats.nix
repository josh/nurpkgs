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
    rev = "5d9a895a1f4655d5f6f5bf2ac4022a0a5314bd5b";
    hash = "sha256-qPvfXWOvsf/PEoRytMNqnjaU+tekShGQrJg/7RT1v8A=";
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
