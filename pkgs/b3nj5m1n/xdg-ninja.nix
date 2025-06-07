{
  xdg-ninja,
  fetchFromGitHub,
  nix-update-script,
}:
xdg-ninja.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "0.2.0.2-unstable-2025-06-07";

    src = fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "42ee421d2d532a75942f7395d20baddf23ed7164";
      hash = "sha256-LIW49kWxfb/oVXkd4xUP6bsoBqcbdZSUjAZbDHVqPp0=";
    };

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  }
)
