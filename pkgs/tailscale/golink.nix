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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "42765dea97afa9f9f5ea167fb0df6f5372d78481";
    hash = "sha256-M+EJsr6z05heKk6iuh3RWZS+9gAMBwG9IyryACVpOy0=";
  };

  vendorHash = "sha256-NRA2JaRgcdlezziAyavdrYVGcIPqoPp6Fpfd3esvFT8=";

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
