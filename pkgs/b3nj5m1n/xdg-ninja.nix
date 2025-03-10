{
  xdg-ninja,
  fetchFromGitHub,
  nix-update-script,
}:
xdg-ninja.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "0.2.0.2-unstable-2025-03-09";

    src = fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "a964a4a4a9b2e34eb3f684f72f5c751c18b27348";
      hash = "sha256-rFGVRbjpXBDS8qae9xv9pL6dNlZNN/WYC3taUFK8O2U=";
    };

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  }
)
