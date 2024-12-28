{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "wikidata-rdf-patch";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "wikidata-rdf-patch";
    rev = "v${version}";
    hash = "sha256-a6dlM3Rn078eTELgjVV5hJN4TSizzuVlLJQEinYu+rc=";
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
