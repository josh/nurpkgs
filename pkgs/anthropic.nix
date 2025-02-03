{ fetchFromGitHub, python3Packages }:
python3Packages.anthropic.overrideAttrs rec {
  version = "0.45.2";
  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-/QuAUU0/nNhJZouCP0LVkCFMTiNdeze/fF+SZKD1Jis=";
  };

  doInstallCheck = false;

  passthru.updateScriptVersion = "stable";
}
