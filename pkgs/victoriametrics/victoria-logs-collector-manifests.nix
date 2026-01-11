{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "victoria-logs-collector-manifests";
  version = "0.2.5";

  src = fetchzip {
    url = "https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-logs-collector-0.2.5/victoria-logs-collector-0.2.5.tgz";
    sha256 = "1vykbn3gs7pcv72yjyhxgkbac42vz3xbfj8yhwp6wmj6zpfn92fa";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "victoria-logs-collector";
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
    "victoria-logs-collector"
  ];

  meta = {
    description = "VictoriaLogs Collector - collects logs from Kubernetes containers and stores them to VictoriaLogs";
    homepage = "https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-collector";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
