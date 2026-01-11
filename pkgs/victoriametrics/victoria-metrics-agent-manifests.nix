{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "victoria-metrics-agent-manifests";
  version = "0.29.0";

  src = fetchzip {
    url = "https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-metrics-agent-0.29.0/victoria-metrics-agent-0.29.0.tgz";
    sha256 = "14aay6lfmnjigbin3nvwmnj9gywr12z0p7907x35536mv8ilwvgv";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "victoria-metrics-agent";
  helmArgs = [ ];
  helmValues = {
    remoteWrite = [
      { url = "http://victoria-logs:9428"; }
    ];
  };

  buildPhase = ''
    runHook preBuild
    yq --yaml-output '.helmValues' "$NIX_ATTRS_JSON_FILE" >values.yaml
    helm template "$helmChartName" "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./"$helmChartName"/* $out
    runHook postInstall
  '';

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://victoriametrics.github.io/helm-charts"
    "--chart"
    "victoria-metrics-agent"
  ];

  meta = {
    description = "VictoriaMetrics Agent - collects metrics from various sources and stores them to VictoriaMetrics";
    homepage = "https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-collector";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
