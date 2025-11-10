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
  version = "0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-ceph-server";
    rev = "4f1d632c40fcc36ecdc356bec6b726c376c6ac87";
    hash = "sha256-oYgkasRmLDEcKJqpA0Q7mJAJBrpyzrT18KhtES/UJ0g=";
  };

  vendorHash = "sha256-tWhP/YnSQ1vxQxxucjxQicXZHO3ON5OqAlHKyCy+cUM=";

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
