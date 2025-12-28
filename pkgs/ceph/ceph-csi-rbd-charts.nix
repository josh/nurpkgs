{
  lib,
  stdenvNoCC,
  fetchzip,
  kubernetes-helm,
  yq,
  nur,
}:
stdenvNoCC.mkDerivation {
  pname = "ceph-csi-rbd-charts";
  version = "3.15.1";

  src = fetchzip {
    url = "https://ceph.github.io/csi-charts/rbd/ceph-csi-rbd-3.15.1.tgz";
    sha256 = "16miwsymyh8aa6lywgv9263wp7vn4jrzilx72rb6gzk292frkadm";
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

  passthru.updateScript = [
    "${lib.getExe nur.repos.josh.nixhelm-update}"
    "--url"
    "https://ceph.github.io/csi-charts"
    "--chart"
    "ceph-csi-rbd"
  ];

  meta = {
    description = "Container Storage Interface (CSI) driver, provisioner, snapshotter, resizer and attacher for Ceph RBD";
    homepage = "https://github.com/ceph/ceph-csi/tree/devel/charts/ceph-csi-rbd";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
