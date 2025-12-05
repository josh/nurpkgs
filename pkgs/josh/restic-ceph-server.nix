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
  version = "0-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-ceph-server";
    rev = "91f4c21717d7ac645ed475c7cd7e5754100a3b49";
    hash = "sha256-ciI0yzgdSlHr2vXCXWAQA/bFIAFCezuDIQNlfPsOYIE=";
  };

  vendorHash = "sha256-J1wYrKyZ8DkTMnJ/TxrAYrW295dsnLaXptblW5wZw0I=";

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
