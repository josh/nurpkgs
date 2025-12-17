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
    rev = "83c83072e0ee796a0a8e35838c6780d458b3e988";
    hash = "sha256-qOyjWG6YfecaGKnBuo1RqGkC0B3pz41b2fvvzMZ6ZGo=";
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
