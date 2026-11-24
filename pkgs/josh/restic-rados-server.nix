{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ceph,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "restic-rados-server";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-rados-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LrUB0cTDYsPnZaxRHQdn7zKiq4KhONOAjJk52D/mbhY=";
  };

  vendorHash = "sha256-oGOzjKeLOAwlferQMRCkIlLiTofQmiXVqzbXZF4sdkw=";

  buildInputs = [
    ceph
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

  };

  meta = {
    description = "Restic repository backend that stores data in raw Ceph RADOS";
    homepage = "https://github.com/josh/restic-rados-server";
    license = lib.licenses.mit;
    mainProgram = "restic-rados-server";
    inherit (ceph.meta) platforms;
  };
})
