{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "nats-chart";
  version = "2.12.3";

  src = fetchzip {
    url = "https://github.com/nats-io/k8s/releases/download/nats-2.12.3/nats-2.12.3.tgz";
    sha256 = "0pdfabb08b2plfns4ax3xjrwmq6z30qgrkgb1y0w0fjzvm28wz7g";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "nats";
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
    "nats"
  ];

  meta = {
    description = "A Helm chart for the NATS.io High Speed Cloud Native Distributed Communications Technology.";
    homepage = "https://github.com/nats-io/k8s/tree/main/helm/charts/nats";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
