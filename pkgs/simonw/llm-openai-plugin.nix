{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-openai-plugin";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openai-plugin";
    tag = version;
    hash = "sha256-87T3zO3KFEW3Gr8hTrYuEdI2Ngv88rx9c02Sos0/7Oo=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.llm
  ];

  dependencies = [ ];

  pythonImportsCheck = [
    "llm_openai"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "OpenAI plugin for LLM";
    homepage = "https://github.com/simonw/llm-openai-plugin";
    changelog = "https://github.com/simonw/llm-openai-plugin/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
