# See <https://github.com/josh/github_exporter/blob/main/package.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "prometheus-github-exporter";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "github_exporter";
    rev = "ae12b151b29b6e9c3e68bd919c6c93fb5143ec0e";
    hash = "sha256-16gUGRGww8HNyhLq02wde8uar/r/kSRJN26BQtwzvbk=";
  };

  vendorHash = "sha256-SP4tQ+CFmdm+0Ww25IAFW5RL1EzUQsq1/LallwJ1ZT4=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for GitHub metrics";
    homepage = "https://github.com/josh/github_exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "github_exporter";
  };
}
