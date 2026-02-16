{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "golink";
  version = "1.0.0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "aa7bf1ac37c3aef31cec15df191c2d945ce068ed";
    hash = "sha256-fq67YBaoior7/KlzKtrvr9l2zUBSlk/UJeia0Kw5RE0=";
  };

  vendorHash = "sha256-ZNRwndYX+goaQMk6cluOHZTOvMd4rF4TkG5560dM6HI=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help = runCommand "test-golink-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      golink --help
      touch $out
    '';
  };

  meta = {
    description = "Private shortlink service for tailnets";
    homepage = "https://github.com/tailscale/golink";
    license = lib.licenses.bsd3;
    mainProgram = "golink";
    broken = lib.strings.versionOlder go.version "1.25.1";
  };
})
