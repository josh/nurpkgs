{
  xdg-ninja,
  fetchFromGitHub,
  nix-update-script,
}:
xdg-ninja.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "0.2.0.2-unstable-2025-05-11";

    src = fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = "xdg-ninja";
      rev = "8e8fc89f03b94171c94acf36cbcc325df9bc9d63";
      hash = "sha256-KoVLskeQBHD3oUrSjcv0BCN573MCc1HXjGKV0Rw8EWA=";
    };

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  }
)
