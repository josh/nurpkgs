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
  version = "0-unstable-2025-12-16";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-ceph-server";
    rev = "8465c9077d682e150d8dbded2793b2ccb4ef0195";
    hash = "sha256-UTxvwwiYCjy6qWTHbHfX3gzcOuBj0DUQbZaXLNmY05w=";
  };

  vendorHash = "sha256-Gyr2aSPTDuAusEL0wtrseHSL4/gnxgu5MvWL/WzkMcY=";

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
