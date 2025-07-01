{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "tsbridge";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jtdowney";
    repo = "tsbridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-COhW8hfaE3L2S42OZfGiWxunY1nW0OKYyzm2u6r34cM=";
  };

  vendorHash = "sha256-iG+7m+uXaWkCRo7PCnWvKpj6fQnCb7d1IztLk1a8Ga8=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-systemd-age-creds-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          tsbridge --help
          touch $out
        '';
  };

  meta = {
    description = "A lightweight proxy manager built on Tailscale's tsnet library that enables multiple HTTPS services on a Tailnet";
    mainProgram = "tsbridge";
    homepage = "https://github.com/jtdowney/tsbridge";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
