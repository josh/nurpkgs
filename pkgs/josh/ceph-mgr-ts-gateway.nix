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
    rev = "b52385283f0597d99872498042f8a4b45c9c74bc";
    hash = "sha256-8ysPoRZwkBHa7XNXoTrHpjtR5KUmjAGIx1Wd5BI1hUY=";
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
