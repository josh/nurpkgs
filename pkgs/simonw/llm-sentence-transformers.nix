{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-sentence-transformers";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-sentence-transformers";
    tag = version;
    hash = "sha256-kW03agLbe0qzcC3JGMbapxUJgJIptYgBigGyRdzV7wI=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.llm
  ];

  dependencies = [
    python3Packages.sentence-transformers
    python3Packages.einops
  ];

  pythonImportsCheck = [
    "llm_sentence_transformers"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "LLM plugin for embeddings using sentence-transformers";
    homepage = "https://github.com/simonw/llm-sentence-transformers";
    changelog = "https://github.com/simonw/llm-sentence-transformers/releases/tag/${version}";
    license = lib.licenses.asl20;

    # https://github.com/NixOS/nixpkgs/commit/4b309c8
    inherit (python3Packages.sentence-transformers.meta) badPlatforms;
  };
}
