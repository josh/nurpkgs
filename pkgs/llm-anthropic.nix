{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "llm-anthropic";
  version = "0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-7+5j5jZBFfaaqnfjvLTI+mz1PUuG8sB5nD59UCpJuR4=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.llm
  ];

  dependencies = [
    python3Packages.anthropic
  ];

  pythonImportsCheck = [
    "llm_anthropic"
  ];

  passthru.updateScriptVersion = "stable";

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
