{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "alacritty-rose-pine";
  version = "0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "alacritty";
    rev = "a3e3d92a6b09c50275974403b3fe049a3bcdf5a1";
    hash = "sha256-5azVVXDEW8hJixouzaNIcr9Qj1MsKmWQpbw5tIj8wwU=";
  };

  buildCommand = ''
    mkdir $out
    cp $src/dist/*.toml $out/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Soho vibes for Alacritty";
    homepage = "https://github.com/rose-pine/alacritty";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
