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
  version = "1.0.1-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tailscale_exporter";
    rev = "25dc7fe5d8b70ed288db848c3d28dc305b84813a";
    hash = "sha256-HJkvA0CmAF//fpLLXJH6eKkujoWiFWKm5370MT3uBF0=";
  };

  vendorHash = "sha256-DYtmjOElvDXYuJAXIbHauf0SvwQC78GBFS65l/OslwU=";

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
