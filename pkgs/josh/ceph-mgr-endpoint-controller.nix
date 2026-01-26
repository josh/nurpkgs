{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ceph,
}:
buildGoModule {
  pname = "ceph-mgr-endpoint-controller";
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ceph-mgr-endpoint-controller";
    rev = "001b54b9b936a3d4b22815ada39411157c9124c2";
    hash = "sha256-/xTlNQ+vwPaVtEMw94Te3kisbu6RMX3UtZM8ze31CcA=";
  };

  vendorHash = "sha256-Nk78g43DKAbfOcZMQdDLu2iquUKT72Ed4JuXdFa/M+E=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    ceph
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Kubernetes controller for Ceph Manager service discovery";
    homepage = "https://github.com/josh/ceph-mgr-endpoint-controller";
    license = lib.licenses.mit;
    inherit (ceph.meta) platforms;
    mainProgram = "ceph-mgr-endpoint-controller";
  };
}
