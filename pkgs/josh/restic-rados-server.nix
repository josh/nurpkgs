{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ceph,
  restic,
}:
buildGoModule (finalAttrs: {
  pname = "restic-rados-server";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-rados-server";
    rev = "116fa2c63379ae0693ca49263e77f36ef3215fc4";
    hash = "sha256-0co5PlX9XFe4v9MCW/37kFy8Z6o8gao4l85VY37boUY=";
  };

  vendorHash = "sha256-YJQIf2fXcDnwHXwVpzS/k0xXbKme/Hk60R1h6gSNTSc=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.ResticProgram=${lib.getExe restic}"
  ];

  buildInputs = [
    ceph
  ];

  nativeCheckInputs = [
    ceph
    restic
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A restic repository backend that stores data in raw Ceph RADOS";
    homepage = "https://github.com/josh/restic-rados-server";
    license = lib.licenses.mit;
    inherit (ceph.meta) platforms;
    mainProgram = "restic-rados-server";
  };
})
