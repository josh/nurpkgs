{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rfmoz-grafana-dashboards";
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "rfmoz";
    repo = "grafana-dashboards";
    rev = "2b14327022dbd89fa40a117103297490c724c115";
    hash = "sha256-fYi4BYuFwI8PME3J9Q0pOrDnDPhD5zeal7FAu24uxJc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./prometheus/*.json $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Grafana dashboards";
    homepage = "https://github.com/rfmoz/grafana-dashboards";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
