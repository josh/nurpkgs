{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "victoria-logs-cluster-manifests";
  version = "0.0.25";

  src = fetchzip {
    url = "https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-logs-cluster-0.0.25/victoria-logs-cluster-0.0.25.tgz";
    sha256 = "1bl2x8lcdybz8155k2x8h5i9hlmiamx3mmnq90zb2gqcs6zvyh9v";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "victoria-logs-cluster";
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
    "victoria-logs-cluster"
  ];

  meta = {
    description = "The VictoriaLogs cluster Helm chart deploys VictoriaLogs cluster database in Kubernetes.";
    homepage = "https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-collector";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
