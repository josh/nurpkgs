{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "llm-anthropic";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-eIppCyFu/2VKExkO88iRozC9AVDcRQaUKrNeLU89rrQ=";
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
