{
  lib,
  stdenvNoCC,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cilium-manifests";
  inherit (nur.repos.josh.cilium-chart) version;
  src = nur.repos.josh.cilium-chart;

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "cilium";
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
    description = "A Helm chart for Tailscale Kubernetes operator";
    homepage = "https://github.com/tailscale/tailscale/tree/main/cmd/k8s-operator/deploy/chart";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
