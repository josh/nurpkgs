{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nur,

  makeWrapper,
  python3,

  nix-update-script,
  runCommand,
}:
let
  pythonEnv = python3.withPackages (ps: [
    ps.backoff
    ps.requests
    ps.tqdm
    nur.repos.josh.polars
  ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wikidatabots";
  version = "0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "wikidatabots";
    rev = "0170b863beda77d8b3586208702679f142527a38";
    hash = "sha256-ovy474WKpFZjSpCqNV4CGEyH3CTv745Lcy0Bqsrv4WI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wikidatabots
    for f in *.py; do
      case "$f" in
        test_*) ;;
        *) install -m644 "$f" $out/share/wikidatabots/ ;;
      esac
    done

    for script in wd_tmdb wd_opencritic; do
      makeWrapper ${lib.getExe pythonEnv} $out/bin/''${script//_/-} \
        --add-flags $out/share/wikidatabots/$script.py
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    imports = runCommand "test-wikidatabots-imports" { } ''
      ${lib.getExe pythonEnv} -c '
      import sys
      sys.path.insert(0, "${finalAttrs.finalPackage}/share/wikidatabots")
      import polars_requests, sparql, wd_opencritic, wd_tmdb, wikidata
      '
      touch $out
    '';
  };

  meta = {
    description = "Wikidata bots running under Josh404Bot";
    homepage = "https://github.com/josh/wikidatabots";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
