{
  lib,
  stdenvNoCC,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "kubernetes-dashboard-manifests";
  inherit (nur.repos.josh.kubernetes-dashboard-chart) version;
  src = nur.repos.josh.kubernetes-dashboard-chart;

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "kubernetes-dashboard";
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

  meta = {
    description = "General-purpose web UI for Kubernetes clusters";
    homepage = "https://github.com/kubernetes/dashboard/tree/master/charts/kubernetes-dashboard";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
