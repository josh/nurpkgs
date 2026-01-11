{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "sops-secrets-operator-manifests";
  version = "0.24.1";

  src = fetchzip {
    url = "https://isindir.github.io/sops-secrets-operator/sops-secrets-operator-0.24.1.tgz";
    sha256 = "1agk8pgm3z10dfharppl481dfcrr67qr8zhx2qj8ll8y3lbvbf1i";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "sops-secrets-operator";
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
    "https://isindir.github.io/sops-secrets-operator/"
    "--chart"
    "sops-secrets-operator"
  ];

  meta = {
    description = "Helm chart deploys sops-secrets-operator";
    homepage = "https://github.com/isindir/sops-secrets-operator/tree/master/chart/helm3/sops-secrets-operator";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
}
