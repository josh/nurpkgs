{ fetchurl, mas }:
mas.overrideAttrs (
  finalAttrs: _previousAttrs: {
    version = "2.1.0";
    src = fetchurl {
      url = "https://github.com/mas-cli/mas/releases/download/v${finalAttrs.version}/mas-${finalAttrs.version}.pkg";
      hash = "sha256-pT8W/ZdNP7Fv5nyTX9vKbTa2jIk3THN1HVCmuEIibfc=";
    };
  }
)
