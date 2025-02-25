{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-gemini";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    tag = version;
    hash = "sha256-xYtfIajEU1iqHvSPDLmg9lHEllcKpVYyUuNZUGNcccw=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.llm
  ];

  dependencies = [
    python3Packages.httpx
    python3Packages.ijson
  ];

  pythonImportsCheck = [
    "llm_gemini"
  ];

  passthru.updateScriptVersion = "stable";

  meta = {
    description = "LLM plugin to access Google's Gemini family of models";
    homepage = "https://github.com/simonw/llm-gemini";
    changelog = "https://github.com/simonw/llm-gemini/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
