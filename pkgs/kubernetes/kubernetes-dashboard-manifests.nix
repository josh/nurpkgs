{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "kubernetes-dashboard-manifests";
  version = "7.14.0";

  src = fetchzip {
    url = "https://github.com/kubernetes/dashboard/releases/download/kubernetes-dashboard-7.14.0/kubernetes-dashboard-7.14.0.tgz";
    sha256 = "0w44sai3sb8xd23c45vxz819njssy39kysl2pdcjz9byxl6yyhcz";
  };

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

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://kubernetes.github.io/dashboard"
    "--chart"
    "kubernetes-dashboard"
  ];

  meta = {
    description = "General-purpose web UI for Kubernetes clusters";
    homepage = "https://github.com/kubernetes/dashboard/tree/master/charts/kubernetes-dashboard";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
