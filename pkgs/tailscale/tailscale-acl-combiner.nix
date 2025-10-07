{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "tailscale-acl-combiner";
  version = "0-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "tailscale-dev";
    repo = "tailscale-acl-combiner";
    rev = "0940cdda6881773ee0a4ad1f10fa3d3b4811c6ea";
    hash = "sha256-/kSINU/TZUkxTCDexBft4IRRxThKjAZ39XsGs/pt1yQ=";
  };

  vendorHash = "sha256-kbhaEwWzLxKX4VmnbChrVn2L+0cMbyUWAnW4Ih9F4WU=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    build-info =
      runCommand "test-tailscale-acl-combiner" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          tailscale-acl-combiner --help
          touch $out
        '';
  };

  meta = {
    description = "A CLI tool to combine multiple Tailscale ACL files into one";
    homepage = "https://github.com/tailscale-dev/tailscale-acl-combiner";
    license = lib.licenses.bsd3;
    mainProgram = "tailscale-acl-combiner";
    platforms = lib.platforms.all;
  };
})
