{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "rsshub-chart";
  version = "0.2.9";

  src = fetchzip {
    url = "https://github.com/NaturalSelectionLabs/helm-charts/releases/download/rsshub-0.2.9/rsshub-0.2.9.tgz";
    sha256 = "sha256-CZ5JBgeVTVS0yNYpmX/CWN6MzlQ9ylVcbaEHAmVcSCA=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "rsshub";
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
    "https://naturalselectionlabs.github.io/helm-charts"
    "--chart"
    "rsshub"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/NaturalSelectionLabs/helm-charts/tree/main/charts/rsshub";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
}
