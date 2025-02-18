{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  testers,
}:
let
  wikidata-rdf-patch = python3Packages.buildPythonApplication rec {
    __structuredAttrs = true;

    pname = "wikidata-rdf-patch";
    version = "0.1.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "josh";
      repo = "wikidata-rdf-patch";
      rev = "v${version}";
      hash = "sha256-ol3hjD3er6XTuSIRk04DKNb+IU3S0ynOTC6yrTI7jDY=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
      click
      rdflib
      tqdm
    ];

    meta = {
      description = "Edit Wikidata items with RDF";
      homepage = "https://github.com/josh/wikidata-rdf-patch";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "wikidata-rdf-patch";
    };
  };
in
wikidata-rdf-patch.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    wikidata-rdf-patch = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "stable";

    passthru.tests = {
      version = testers.testVersion {
        package = wikidata-rdf-patch;
        inherit (finalAttrs) version;
      };

      help =
        runCommand "test-wikidata-rdf-patch-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ wikidata-rdf-patch ];
          }
          ''
            wikidata-rdf-patch --help
            touch $out
          '';
    };
  }
)
