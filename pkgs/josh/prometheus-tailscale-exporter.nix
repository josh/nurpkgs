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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tailscale_exporter";
    rev = "1086a721ca2869a01409e15e6e99447c751f8c28";
    hash = "sha256-Th/xNEvq7FZi0vmMVl03JIdBAK0zsaEbATfxxEMo9oY=";
  };

  vendorHash = "sha256-SIJ2bFcR2nCn0jv82rvAGFJhRdfUEdD8VeWi+tiiQig=";

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

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
