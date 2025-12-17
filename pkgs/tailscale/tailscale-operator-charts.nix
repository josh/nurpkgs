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
  version = "1.92.3";

  src = fetchzip {
    url = "https://pkgs.tailscale.com/helmcharts/tailscale-operator-1.92.3-1765984115-2df19b81b415a8e1523f42d292ba7e89e102dd33868c7d8773787826e3272d35.tgz";
    sha256 = "09q66rlxnmrnmr498hx6vkm94p3pcr970igcf0zh9k533hzvgjkc";
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
