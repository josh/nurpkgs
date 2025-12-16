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
  version = "1.90.9";

  src = fetchzip {
    url = "https://pkgs.tailscale.com/helmcharts/tailscale-operator-1.90.9-1764110454-f296725a00530ed9d45e76330c2b5b5ed4f3bd47b7e419ea1dc908fdb06e93ba.tgz";
    sha256 = "0fdd7vf45nhb6db1sm8axcx4725f4wqlymckrmnphyl025ylkqlz";
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
