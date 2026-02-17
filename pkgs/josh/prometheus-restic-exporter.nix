{
  lib,
  buildGoModule,
  fetchFromGitHub,
  restic,
  nix-update-script,
  runCommand,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-restic-exporter";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-exporter";
    rev = "192d0f85e7d97882e61412df177b37b7afdcce10";
    hash = "sha256-DIPAk8+x7iJquWaWHrl3FwptRO1epmjqW0hNYnua0K4=";
  };

  vendorHash = "sha256-oeCSKwDKVwvYQ1fjXXTwQSXNl/upDE3WAAk680vqh3U=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.resticBinary=${lib.getExe restic}"
  ];

  nativeCheckInputs = [
    restic
  ];

  postInstall = ''
    substituteInPlace ./systemd/*.service --replace-fail /usr/bin/restic-exporter $out/bin/restic-exporter
    install -D --mode=0444 --target-directory $out/lib/systemd/system ./systemd/*
  '';

  # TODO: Switch to stable branch
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-prometheus-restic-exporter-help"
        { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          restic-exporter --help
          touch $out
        '';
  };

  meta = {
    description = "Prometheus exporter for Restic metrics";
    homepage = "https://github.com/josh/restic-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "restic-exporter";
  };
})
