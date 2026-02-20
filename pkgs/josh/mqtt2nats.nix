{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "mqtt2nats";
  version = "0-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    rev = "425d9efed551cef94855c4bd1e507022f06a0e11";
    hash = "sha256-qEKz6cJ4s2kH1DvWqIgiK4urVApCUggV6cjD/ilIIW0=";
  };

  vendorHash = "sha256-DlxeSTJl5ImZu3jD11Pcc1ZOQ1SFqwbQ6DL/IVn8FOY=";

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
