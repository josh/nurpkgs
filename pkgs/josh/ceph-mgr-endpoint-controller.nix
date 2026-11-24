{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ceph,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ceph-mgr-endpoint-controller";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ceph-mgr-endpoint-controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UY5O7Ttwd+FUNSNEpYmhKyBO+y9iX35+mIUACMMWuwc=";
  };

  vendorHash = "sha256-wKfVufn2z+6i8EdTSac+uHQb/So4/4B93fZRn2Wk1l4=";

  buildInputs = [
    ceph
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Kubernetes controller for Ceph Manager service discovery";
    homepage = "https://github.com/josh/ceph-mgr-endpoint-controller";
    license = lib.licenses.mit;
    mainProgram = "ceph-mgr-endpoint-controller";
    inherit (ceph.meta) platforms;
  };
})
