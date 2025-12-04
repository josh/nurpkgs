{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "caddy-tailscale";
  version = "0-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "caddy-tailscale";
    rev = "f070d146dd6169aa29376ee9ac5a3e16763f9cb2";
    hash = "sha256-0BPsIRN7r39Vz48l0FzkDnrUysh/km1FMoKRgQeuHU4=";
  };

  vendorHash = "sha256-nA5J6HUg8wxHnNa2o1Zpf9+nXF9b8nq8h/mmpybXKxg=";

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
