{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "tailscale-operator-charts";
  version = "1.90.6";

  src = fetchzip {
    url = "https://pkgs.tailscale.com/helmcharts/tailscale-operator-1.90.6-1761949884-08247dd90325a32ae95c5b116917015458b569eadbd66e7116dcdc7502a82bd9.tgz";
    sha256 = "sha256-cHlHdq+YufyW1YNfFZ3O7U8FbGxZIbg5ryYp6eExReg=";
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
    helm template tailscale-operator "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./tailscale-operator/templates/* $out
    runHook postInstall
  '';

  passthru.updateScript = [ "${lib.getExe nur.repos.josh.tailscale-operator-charts-update-script}" ];

  meta = {
    description = "A Helm chart for Tailscale Kubernetes operator";
    homepage = "https://github.com/tailscale/tailscale/tree/main/cmd/k8s-operator/deploy/chart";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
