{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "mqtt2nats";
  version = "0-unstable-2025-12-18";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    rev = "770ee3bcd9c8c494379f640e675ef4542d55e2d6";
    hash = "sha256-EJvIxzrTy2wevD+onnkSVqZBOCs/D0FOH8s53Y99dgU=";
  };

  vendorHash = "sha256-WPn4GHVRor4BEHStIhRaq3kmjKdZM3v9bkGkt259GCw=";

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
