{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "ceph-csi-cephfs-chart";
  version = "3.15.1";

  src = fetchzip {
    url = "https://ceph.github.io/csi-charts/cephfs/ceph-csi-cephfs-3.15.1.tgz";
    sha256 = "1i20r8vllkqarkynw9rrq3kggk97vv0p3f9vr9g0xcmbsffdd578";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    kubernetes-helm
    yq
  ];

  helmChartName = "ceph-csi-cephfs";
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
    "https://ceph.github.io/csi-charts"
    "--chart"
    "ceph-csi-cephfs"
  ];

  meta = {
    description = "Container Storage Interface (CSI) driver, provisioner, snapshotter, resizer and attacher for Ceph cephfs";
    homepage = "https://github.com/ceph/ceph-csi/tree/devel/charts/ceph-csi-cephfs";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
