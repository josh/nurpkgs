{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-gemini";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    tag = version;
    hash = "sha256-NNzorEb3dVoKef+9eXzStcFAkQhnhMBVnwLBc2lA2+o=";
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "LLM plugin to access Google's Gemini family of models";
    homepage = "https://github.com/simonw/llm-gemini";
    changelog = "https://github.com/simonw/llm-gemini/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
