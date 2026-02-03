{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "argo-cd-manifests";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FvN4JCG/5SxpnmdEH9X1sMX5dNlp/x0ALNysv+LWroU=";
  };

  buildCommand = ''
    mkdir $out
    cp -R $src/manifests/. $out/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Argo CD Kubernetes manifests";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
