{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "caddy-tailscale";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "caddy-tailscale";
    rev = "01d084e119cb2ddb49630edb89bb5c6d7c4e8bc0";
    hash = "sha256-VTxRPTgJ9XE/JU91NQ7OoVLORfCsW8ditJw1Ml2VnfY=";
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
