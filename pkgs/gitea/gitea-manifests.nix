{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "gitea-manifests";
  version = "12.4.0";

  src = fetchzip {
    url = "https://dl.gitea.com/charts/gitea-12.4.0.tgz";
    sha256 = "0y5wxixz20fanb0p8y6jkbjrgkz3k24z70hsjfrzppxgpwaw524c";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "gitea";
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
    "https://dl.gitea.com/charts/"
    "--chart"
    "gitea"
  ];

  meta = {
    description = "Gitea Helm chart for Kubernetes";
    homepage = "https://gitea.com/gitea/helm-gitea";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
