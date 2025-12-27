{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "unpoller-dashboards";
  version = "0-unstable-2025-12-24";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "dashboards";
    rev = "bb8b3dc50f99214b748c31e8d81ca7b2154972a5";
    hash = "sha256-nlSAEKSvyXK7SC3+Lxp9SalJzWomFacajJi2UOnh5mU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R ./v2.0.0/*.json $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "UniFi Poller Grafana Dashboards";
    homepage = "https://github.com/unpoller/dashboards";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
