{
  lib,
  stdenvNoCC,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "sealed-secrets-manifests";
  inherit (nur.repos.josh.sealed-secrets-chart) version;
  src = nur.repos.josh.sealed-secrets-chart;

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "sealed-secrets";
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
    description = "Gitea Helm chart for Kubernetes";
    homepage = "https://gitea.com/gitea/helm-gitea";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
