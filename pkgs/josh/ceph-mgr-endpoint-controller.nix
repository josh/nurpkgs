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
    rev = "1cfdad65c08d759c88542bdec8678b60d2c79782";
    hash = "sha256-0w7b9o5PrvN4G+lzlLSgDn2uIeQj3dNF58M40+SoZ50=";
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
