{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ceph,
}:
buildGoModule {
  pname = "ceph-mgr-endpoint-controller";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ceph-mgr-endpoint-controller";
    rev = "29243c8cf4d3096fe9769ede17380db76f979ded";
    hash = "sha256-s2lbIUPNg0/jWFVjkQgnytFabPeaCWEHKK5WUwx+vSU=";
  };

  vendorHash = "sha256-Nk78g43DKAbfOcZMQdDLu2iquUKT72Ed4JuXdFa/M+E=";

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
