{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "local-path-provisioner-chart";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "local-path-provisioner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0/3kaGyd7z68EXNCiC8YUFXQ7ZbSpLJ1e8vAH3AGCdk=";
  };

  buildCommand = ''
    mkdir $out
    cp -R $src/deploy/chart/local-path-provisioner/* $out/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Dynamically provisioning persistent local storage with Kubernetes";
    homepage = "https://github.com/rancher/local-path-provisioner";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
