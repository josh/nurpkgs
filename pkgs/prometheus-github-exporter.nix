# See <https://github.com/josh/github_exporter/blob/main/package.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "prometheus-github-exporter";
  version = "0.1.0-unstable-2024-12-31";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "github_exporter";
    rev = "e0652108a81b26db209007c08638a848a8f932c6";
    hash = "sha256-+DsMdqOJPSbjLki+23fROcog2rDYn5jsPnOcEfckcys=";
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
