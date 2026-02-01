{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "mqtt2nats";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    rev = "0d39e0b3e3cd8e0ea558fc4583f3337b54c0e21a";
    hash = "sha256-NeOrcV734x4t+9GdEAwrb+PVraoNKbarkbn/Hx3loOo=";
  };

  vendorHash = "sha256-MMIBjGIP7PocQfJlp6tcyjTLMfvVK3nmu41C4UCo6UQ=";

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
