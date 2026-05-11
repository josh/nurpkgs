{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "victoria-metrics-dashboards";
  version = "1.143.0-cluster";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0qcyxE7jPyl28B/HkhQIXW4vCwJBCk6yNgif7Ms1Ni4=";
  };

  outputs = [
    "out"
    "prometheus"
    "vm"
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out $prometheus $vm
    cp ./dashboards/*.json $out/
    cp ./dashboards/*.json $prometheus/
    cp ./dashboards/vm/*.json $vm/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "VictoriaMetrics Grafana Dashboards";
    homepage = "https://github.com/VictoriaMetrics/VictoriaMetrics/tree/main/dashboards";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
