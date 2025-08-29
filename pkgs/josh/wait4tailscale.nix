{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "wait4tailscale";
  version = "0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "wait4tailscale";
    rev = "8263e4040fd7358533749fb5851c2f3104fab98e";
    hash = "sha256-dmlT6rbLn6YzNAL1AhRUoZfTpgURbJ+kN/xjbD8yjw8=";
  };

  vendorHash = "sha256-XBEF+agJ3t30UJufzFmkSuoNA5vpFA3Dsbz7Un+tObM=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    substituteInPlace ./systemd/*.service --replace-fail /usr/bin/wait4tailscale $out/bin/wait4tailscale
    install -D --mode=0444 --target-directory $out/lib/systemd/system ./systemd/*
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help = runCommand "test-wait4tailscale-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      wait4tailscale --help
      touch $out
    '';
  };

  meta = {
    description = "Monitor Tailscale connection status";
    homepage = "https://github.com/josh/wait4tailscale";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "wait4tailscale";
  };
})
