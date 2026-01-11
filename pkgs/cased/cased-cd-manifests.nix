{
  lib,
  stdenvNoCC,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cased-cd-manifests";
  inherit (nur.repos.josh.cased-cd-chart) version;
  src = nur.repos.josh.cased-cd-chart;

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "cased-cd";
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
    description = "A modern UI for ArgoCD";
    homepage = "https://github.com/cased/cased-cd";
    license = lib.licenses.fsl11Asl20;
    platforms = lib.platforms.all;
  };
}
