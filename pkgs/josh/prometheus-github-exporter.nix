{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-github-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "github_exporter";
    rev = "bd1b395d7feed6fe53a19dc38da76e9e845b0380";
    hash = "sha256-JJvm6s4XEcGoHq4tWj70Atf+LzXc8cNlaB0nGnC0gpQ=";
  };

  vendorHash = "sha256-iYCPQS2L6kbiELTUREHSm7mCGGVFS1yrJQKrTDwKdV0=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    substituteInPlace ./systemd/*.service --replace-fail /usr/bin/github_exporter $out/bin/github_exporter
    install -D --mode=0444 --target-directory $out/lib/systemd/system ./systemd/*
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-prometheus-github-exporter-help"
        { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          github_exporter --help
          touch $out
        '';
  };

  meta = {
    description = "Prometheus exporter for GitHub metrics";
    homepage = "https://github.com/josh/github_exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "github_exporter";
  };
})
