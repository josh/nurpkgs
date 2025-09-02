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
  version = "0.1.0-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "wait4tailscale";
    rev = "de433bde8c00df4e1c47447e76231fac39ab224a";
    hash = "sha256-b0Sln21ryxbowRKtdoxLx3HzyVADDe7+vyG5Vo1MNK0=";
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
