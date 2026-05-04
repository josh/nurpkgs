{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
}:
buildGoModule {
  pname = "ceph-mgr-ts-gateway";
  version = "0-unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ceph-mgr-ts-gateway";
    rev = "fa5c960122cf96535cf87e108941f077dc6fbea8";
    hash = "sha256-Ly9uvrTxyshT4DDvGPYjaTWLly/yUPZ1iXW1lJ8k+4A=";
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
