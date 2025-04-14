{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-openai-plugin";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openai-plugin";
    tag = version;
    hash = "sha256-hc7MDPpmYwgQxBYRWAFzWVVs3ihqi3RQeozJzwWl/GI=";
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
