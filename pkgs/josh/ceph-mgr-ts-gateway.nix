{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
}:
buildGoModule {
  pname = "ceph-mgr-ts-gateway";
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ceph-mgr-ts-gateway";
    rev = "cb2c2f6b7f9afde2888bfdb4cde528fbfe5690ad";
    hash = "sha256-2k4JpPIbwlg6DICVvCfFQM/Cmv8SPWbb6RcnTIkMwAs=";
  };

  vendorHash = "sha256-PV3E0vl9QPtw8xFWSWbF5x0IoqWNf37XIRhvTJ7fSUk=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Ceph Manager Tailscale Gateway";
    homepage = "https://github.com/josh/ceph-mgr-ts-gateway";
    license = lib.licenses.mit;
    mainProgram = "ceph-mgr-ts-gateway";
    broken = lib.strings.versionOlder go.version "1.26.1";
  };
}
