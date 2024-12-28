# See <https://github.com/josh/github_exporter/blob/main/package.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "prometheus-github-exporter";
  version = "0-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "github_exporter";
    rev = "5f2ae1bcf197e5e3dcbb8b4a6cd0374f2fac42c0";
    hash = "sha256-xGHtEjLSHbVq1hR4LkVMY7q35YZT33dpwmPXZ7KwZag=";
  };

  vendorHash = "sha256-TByHG/Fk20Bh9qI+tTwBFm47A0kb+SCc7hQ8s9RkwKk=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScriptVersion = "branch";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Prometheus exporter for GitHub metrics";
    homepage = "https://github.com/josh/github_exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "github_exporter";
  };
}
