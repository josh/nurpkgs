{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "unpoller-dashboards";
  version = "0-unstable-2025-11-27";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "dashboards";
    rev = "643b344156a7b241e15f348d1760363d0db30ea7";
    hash = "sha256-qF2WwtXszHytLD1fKZlGR5EvhZ9GxGL77ti4Q0t36hk=";
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
