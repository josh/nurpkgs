{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "caddy-tailscale";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "caddy-tailscale";
    rev = "aea8960a2d3c8099e88fe3a999b559bfdfac64a7";
    hash = "sha256-W0y81Q15OLXFAGXmyb1HC/fMNpyngWMlXmi7+y54FsQ=";
  };

  vendorHash = "sha256-5osC3IVuF7DG9WKsIMZ2rVjz/7PhldmAuTHdg9wy5/w=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    build-info =
      runCommand "test-caddy-build-info" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          caddy build-info | grep "github.com/tailscale/caddy-tailscale"
          touch $out
        '';
  };

  meta = {
    description = "A highly experimental exploration of integrating Tailscale and Caddy";
    homepage = "https://github.com/tailscale/caddy-tailscale";
    license = lib.licenses.mit;
    mainProgram = "caddy";
    platforms = lib.platforms.all;
  };
})
