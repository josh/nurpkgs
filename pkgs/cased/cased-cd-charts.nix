{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cased-cd-charts";
  version = "0.2.19";

  src = fetchzip {
    url = "https://cased.github.io/cased-cd/cased-cd-0.2.19.tgz";
    sha256 = "1zkx35p869wdr7p39hqdii7bd3rn14iyz50i6mv1d532mg2174q0";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmArgs = [ ];
  helmValues = { };

  buildPhase = ''
    runHook preBuild
    yq --yaml-output '.helmValues' "$NIX_ATTRS_JSON_FILE" >values.yaml
    helm template cased-cd "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./cased-cd/templates/* $out
    runHook postInstall
  '';

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://cased.github.io/cased-cd"
    "--chart"
    "cased-cd"
  ];

  meta = {
    description = "A modern UI for ArgoCD";
    homepage = "https://github.com/cased/cased-cd";
    license = lib.licenses.fsl11Asl20;
    platforms = lib.platforms.all;
  };
}
