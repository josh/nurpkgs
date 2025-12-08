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
  version = "1.0.0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "491554abd506a48221631bea0e014ca5c8f53fcd";
    hash = "sha256-RPW2sQFaoQdSNPVg6cq94YVbf6SeBCuGnpjMIxtvpbM=";
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
