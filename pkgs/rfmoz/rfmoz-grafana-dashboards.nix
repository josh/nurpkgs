{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rfmoz-grafana-dashboards";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "rfmoz";
    repo = "grafana-dashboards";
    rev = "1927a8ae816884c17cf2502ec51297382ee92450";
    hash = "sha256-GdlP25hHP3guCCZya+G/gTh1lfYGClwCu2c1HmiYtGs=";
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
