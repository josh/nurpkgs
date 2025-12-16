{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ceph-csi-rbd-charts";
  version = "3.15.1";

  src = fetchzip {
    url = "https://ceph.github.io/csi-charts/rbd/ceph-csi-rbd-${finalAttrs.version}.tgz";
    sha256 = "sha256-tamZnUhi/mdWFqfT+LMkdp/LhxFpP+6pUQpBX73msZo=";
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
    helm template ceph-csi-rbd "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./ceph-csi-rbd/templates/* $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://github.com/ceph/ceph-csi"
      "--version=stable"
    ];
  };

  meta = {
    description = "The ceph-csi-rbd chart adds rbd volume support to your cluster";
    homepage = "https://github.com/ceph/ceph-csi/tree/devel/charts/ceph-csi-rbd";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
