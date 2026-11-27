{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "mqtt2nats";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "mqtt2nats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TRsealGaLS53zEzRS6Pck6kTqipS9jI99TYtGPaWvgY=";
  };

  vendorHash = "sha256-nxJOYEPVjuK+4EljG9pbMSzewLV8iW5p5nAp8pdxTl4=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help = runCommand "test-mqtt2nats-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      mqtt2nats --help
      touch $out
    '';
  };

  meta = {
    description = "Relay MQTT messages to NATS";
    homepage = "https://github.com/josh/mqtt2nats";
    license = lib.licenses.mit;
    mainProgram = "mqtt2nats";
  };
})
