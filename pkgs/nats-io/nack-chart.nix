{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "nack-chart";
  version = "0.31.1";

  src = fetchzip {
    url = "https://github.com/nats-io/k8s/releases/download/nack-0.31.1/nack-0.31.1.tgz";
    sha256 = "04lmij4m78ljb9dl466dwvmxlqx1ldryp9hd1496n0akyymddvyx";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "nack";
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
    "https://nats-io.github.io/k8s/helm/charts"
    "--chart"
    "nack"
  ];

  meta = {
    description = "A Helm chart for NACK - NAts Controller for Kubernetes";
    homepage = "https://github.com/nats-io/k8s/tree/main/helm/charts/nack";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
