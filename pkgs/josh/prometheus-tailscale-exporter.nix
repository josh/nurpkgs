{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-tailscale-exporter";
  version = "0.1.0-unstable-2025-08-02";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tailscale_exporter";
    rev = "87d12e6ed12781cca1ea5d81210ac9e03f25986a";
    hash = "sha256-VZEdRMPnNTQr4aG7pchR1X7qJhqsaAY4SFoBx3m+N3k=";
  };

  vendorHash = "sha256-JbqQu2WSfnWLulXchEyXKpmLmDlyZ8RMrDSJM4BYWVA=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    substituteInPlace ./systemd/*.service --replace-fail /usr/bin/tailscale_exporter $out/bin/tailscale_exporter
    install -D --mode=0444 --target-directory $out/lib/systemd/system ./systemd/*
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-prometheus-tailscale-exporter-help"
        { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          tailscale_exporter --help
          touch $out
        '';
  };

  meta = {
    description = "Prometheus exporter for Tailscale metrics";
    homepage = "https://github.com/josh/tailscale_exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "tailscale_exporter";
  };
})
