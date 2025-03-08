{
  xdg-ninja,
  fetchFromGitHub,
  nix-update-script,
}:
xdg-ninja.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "0.2.0.2-unstable-2025-02-23";

    src = fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "8a3d7751d18a64dcab9245f03b9cb0829ca08471";
      hash = "sha256-dHDNSQOnkO/sRvHZz13dhf8ghhZ+gcN2aQTQXRH8+P8=";
    };

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  }
)
