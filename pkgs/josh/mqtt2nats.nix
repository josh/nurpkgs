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
    rev = "f996c621f3e0f49a074417b91315f772b708d10d";
    hash = "sha256-kRxW5uwp+pdsz08IwLxMykWgb47H9f8UXsgaIqNpgnE=";
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
