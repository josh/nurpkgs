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
  version = "0-unstable-2026-02-14";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-exporter";
    rev = "24231eeb625f4d0d94287268106433f103f396df";
    hash = "sha256-Js2NFAHC3TE1CgSUiSIThb7RPsPtecHGePuHQO/Plwg=";
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
