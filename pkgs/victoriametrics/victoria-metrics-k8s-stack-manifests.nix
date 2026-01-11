{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "victoria-metrics-k8s-stack-manifests";
  version = "0.67.0";

  src = fetchzip {
    url = "https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-metrics-k8s-stack-0.67.0/victoria-metrics-k8s-stack-0.67.0.tgz";
    sha256 = "0h5g5xi8rywfwdigvf0g9bv3yna9kn75y90kwv2xmjisvj2hlrss";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "victoria-metrics-k8s-stack";
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
    "victoria-metrics-k8s-stack"
  ];

  meta = {
    description = "Kubernetes monitoring on VictoriaMetrics stack. Includes VictoriaMetrics Operator, Grafana dashboards, ServiceScrapes and VMRules";
    homepage = "https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-collector";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
