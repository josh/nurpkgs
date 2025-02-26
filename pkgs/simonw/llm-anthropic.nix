{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "llm-anthropic";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-tKgcag8sBJA4QWunaFyZxkZH0mtc0SS17104YuX1Kac=";
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
