{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "jmap2nats";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "jmap2nats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+3AjzexKRwZZpu1jvFTuBarqOVQd1jR2Y+92GN0ZFE4=";
  };

  vendorHash = "sha256-PkpTDdzlQgGDx+hnWNftV2xJsVgIPGqKdhoj6Asox/4=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help = runCommand "test-jmap2nats-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      jmap2nats --help
      touch $out
    '';
  };

  meta = {
    description = "Bridge JMAP email push events to NATS JetStream";
    homepage = "https://github.com/josh/jmap2nats";
    license = lib.licenses.mit;
    mainProgram = "jmap2nats";
  };
})
