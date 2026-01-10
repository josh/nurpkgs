{
  lib,
  stdenvNoCC,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cased-cd-enterprise-manifests";
  inherit (nur.repos.josh.cased-cd-enterprise-chart) version;
  src = nur.repos.josh.cased-cd-enterprise-chart;

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "cased-cd-enterprise";
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
    description = "A modern UI for ArgoCD with enterprise features (RBAC, audit trail, user management)";
    homepage = "https://github.com/cased/cased-cd-enterprise";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
