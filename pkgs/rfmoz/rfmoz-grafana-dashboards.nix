{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rfmoz-grafana-dashboards";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "rfmoz";
    repo = "grafana-dashboards";
    rev = "dbc63463ace4ef635f003bf7198fc211571d46a8";
    hash = "sha256-5e5xp68qQifONmPRC3Ss4dDXxF+tfGgkQpvwcEhVL6U=";
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
