{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ceph-csi-cephfs-charts";
  version = "3.15.1";

  src = fetchzip {
    url = "https://ceph.github.io/csi-charts/cephfs/ceph-csi-cephfs-${finalAttrs.version}.tgz";
    sha256 = "sha256-6JTWnNOrsg5eyju5ccHeJ8335sA5J279zApPSjfKQMQ";
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
    helm template ceph-csi-cephfs "$src" --output-dir . --values values.yaml "''${helmArgs[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./ceph-csi-cephfs/templates/* $out
    runHook postInstall
  '';

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://ceph.github.io/csi-charts"
    "--chart"
    "cceph-csi-cephfs"
  ];

  meta = {
    description = "The ceph-csi-cephfs chart adds cephFS volume support to your cluster.";
    homepage = "https://github.com/ceph/ceph-csi/tree/devel/charts/ceph-csi-cephfs";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
