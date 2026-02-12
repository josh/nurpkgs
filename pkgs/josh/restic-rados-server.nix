{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
  ceph,
  restic,
}:
buildGoModule (finalAttrs: {
  pname = "restic-rados-server";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-rados-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pVy+yu+WgV95wSH2igRd1yaVE9N2l6CRg4IFCGsWQLc=";
  };

  vendorHash = "sha256-YJQIf2fXcDnwHXwVpzS/k0xXbKme/Hk60R1h6gSNTSc=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  buildInputs = [
    ceph
  ];

  nativeCheckInputs = [
    ceph
    restic
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-restic-rados-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          restic-rados-server --help
          touch $out
        '';
  };

  meta = {
    description = "A restic repository backend that stores data in raw Ceph RADOS";
    homepage = "https://github.com/josh/restic-rados-server";
    license = lib.licenses.mit;
    inherit (ceph.meta) platforms;
    mainProgram = "restic-rados-server";
  };
})
