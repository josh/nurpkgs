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
    rev = "fc4c23e5583f6112c84f61e58da52171a00f2d78";
    hash = "sha256-JKxu+516ghkaMD45pV1GDhiIPyjM9CxG0BR2x6N4FWw=";
  };

  vendorHash = "sha256-7p2HyKKanP0xTa7+4SH7eyu0esflNmsuji/7lZTcvbQ=";

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
