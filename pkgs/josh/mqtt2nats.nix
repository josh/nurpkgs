{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "mqtt2nats";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    rev = "095aa3f3b94fcde0354777941cd3b639c699646c";
    hash = "sha256-uNKW2BwoNK0KXCSY+liOc3jsaHodnbSly9cIDClcQ20=";
  };

  vendorHash = "sha256-eCKmxRhmtDqZhd7Rdgu983VixZwKD9GXQQLrvidjGY8=";

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
