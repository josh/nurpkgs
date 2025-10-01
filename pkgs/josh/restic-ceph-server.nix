{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ceph,
  restic,
}:
buildGoModule (finalAttrs: {
  pname = "restic-ceph-server";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-ceph-server";
    rev = "6cd7837563c39bb40ca7c15295ec10a34b79b364";
    hash = "sha256-J6viB449k7yWS6ke6VVH43UOnWpvdN8KESMhy4uTcAw=";
  };

  vendorHash = "sha256-zBEeT1Ex/jhaNN0KTeW+OZreQVe2nzJKKyVXuK8Wg7o=";

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
    homepage = "https://github.com/josh/restic-ceph-server";
    license = lib.licenses.mit;
    inherit (ceph.meta) platforms;
    mainProgram = "restic-ceph-server";
  };
})
