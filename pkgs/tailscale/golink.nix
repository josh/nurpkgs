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
  version = "1.0.0-unstable-2025-11-26";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "6821994de926c565d3ef9fbf3cb0e0fcb780f4be";
    hash = "sha256-4c9jCOfkKNRHJLXgOIcVcNSaw/XaiVaqesaLJn86wGA=";
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
