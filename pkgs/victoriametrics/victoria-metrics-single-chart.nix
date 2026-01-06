{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "victoria-metrics-single-chart";
  version = "0.28.0";

  src = fetchzip {
    url = "https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-metrics-single-0.28.0/victoria-metrics-single-0.28.0.tgz";
    sha256 = "0nmpcds24bqls619cw62kybwrn9zh8038d5w77s5k2acrqamd8kj";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "victoria-metrics-single";
  helmArgs = [ ];
  helmValues = { };

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
    "victoria-metrics-single"
  ];

  meta = {
    description = "VictoriaMetrics Single version - high-performance, cost-effective and scalable TSDB, long-term remote storage for Prometheus";
    homepage = "https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-collector";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
