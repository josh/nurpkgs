{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ceph,
  nix-update-script,
}:
buildGoModule {
  pname = "nix-rados-cache";
  version = "0-unstable-2026-11-26";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "nix-rados-cache";
    rev = "1e4cc1200e12d792a6889a210d903b7c94fe1cc0";
    hash = "sha256-Zg+MYih9RasPvgHEnhTFp323DtXBWhJ9QBErKnqo6r0=";
  };

  vendorHash = "sha256-TkLtn2oWT7kBMFw/KWqR6ktHsDfPV/w/JHTXjXEcIrU=";

  buildInputs = [
    ceph
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Nix HTTP binary cache backed by Ceph RADOS via librados";
    homepage = "https://github.com/josh/nix-rados-cache";
    license = lib.licenses.mit;
    mainProgram = "nix-rados-cache";
    inherit (ceph.meta) platforms;
  };
}
