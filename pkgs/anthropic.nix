{ fetchFromGitHub, python3Packages }:
python3Packages.anthropic.overrideAttrs rec {
  version = "0.42.0";
  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "anthropic-sdk-python";
    tag = "v${version}";
    hash = "sha256-7cRXKXiyq3ty21klkitjjnm9rzBRmAXGYvvVxTNWeZ4=";
  };

  passthru.updateScriptVersion = "stable";
}
