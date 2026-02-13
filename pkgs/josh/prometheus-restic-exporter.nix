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
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-exporter";
    rev = "cc3c2ad206ca8f70fdf393f65c79022585f8c954";
    hash = "sha256-kbiz30/HEdZ4XXPVKB1we6iFUzNdwQ86I1jcxXxOYjY=";
  };

  vendorHash = "sha256-oeCSKwDKVwvYQ1fjXXTwQSXNl/upDE3WAAk680vqh3U=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.resticBinary=${lib.getExe restic}"
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
