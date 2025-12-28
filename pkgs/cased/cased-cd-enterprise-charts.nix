{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cased-cd-enterprise-charts";
  version = "0.2.24";

  src = fetchzip {
    url = "https://cased.github.io/cased-cd-enterprise/cased-cd-enterprise-0.2.24.tgz";
    sha256 = "1z5pp0s7v7khqdibjgw234j2yxradlmxhzbys8i1yq2kgab0jcym";
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
    helm template cased-cd-enterprise "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./cased-cd-enterprise/templates/* $out
    runHook postInstall
  '';

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://cased.github.io/cased-cd-enterprise"
    "--chart"
    "cased-cd-enterprise"
  ];

  meta = {
    description = "A modern UI for ArgoCD with enterprise features (RBAC, audit trail, user management)";
    homepage = "https://github.com/cased/cased-cd-enterprise";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
