{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "cert-manager-chart";
  version = "1.19.2";

  src = fetchzip {
    url = "https://quay.io/v2/jetstack/charts/cert-manager/blobs/sha256:87e2dafa946bd05c56be897b2fe2e171f2bbfad96c9d48409d4b1188d240af6f";
    sha256 = "1yjvhigjx71ags1imcrkjz4i0i6zv5gpdcdn93hp6hjf5x52kxja";
    extension = "tar.gz";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "cert-manager";
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
    "oci://quay.io/jetstack/charts/cert-manager"
  ];

  meta = {
    description = "A Helm chart for cert-manager";
    homepage = "https://cert-manager.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
