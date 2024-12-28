{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
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

  passthru.updateScriptVersion = "stable";

  meta = {
    description = "Edit Wikidata items with RDF";
    homepage = "https://github.com/josh/wikidata-rdf-patch";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "wikidata-rdf-patch";
  };
}
