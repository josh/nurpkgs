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
  version = "1.92.4";

  src = fetchzip {
    url = "https://pkgs.tailscale.com/helmcharts/tailscale-operator-1.92.4-1766063251-a64828964ee38b79448a54e52f5d819da2295ed10856de0c89414aa2e1fc7dc3.tgz";
    sha256 = "0wdl431h6s8rb32hkfkjnx5kvpvxfpmy7vqy05q0ral9m87xnp5q";
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
