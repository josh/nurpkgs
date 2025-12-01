{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "tsbridge";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "jtdowney";
    repo = "tsbridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G8KDD9crv3b1hrA5r+gBGvV4Dn6rT6MEpf/c9S1FuII=";
  };

  vendorHash = "sha256-agNBqIHtWxpio1mK6jhYztEBXBR+D0rf+UgbKR81kaE=";

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

    help = runCommand "test-tsbridge-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
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
