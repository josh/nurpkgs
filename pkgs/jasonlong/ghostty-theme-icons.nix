{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "ghostty-theme-icons";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "jasonlong";
    repo = "ghostty-theme-icons";
    rev = "558ae2580c9e221990430bf347a8fa399648613e";
    hash = "sha256-N0tdAx3j/YFYF9Mz2S6r1pbeBdK4l1jHjIxs87rZHb4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ghostty
    cp ./icons/*/*.icns $out/share/ghostty/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Ghostty icons based on popular terminal colorschemes";
    homepage = "https://github.com/jasonlong/ghostty-theme-icons";
    platforms = lib.platforms.all;
  };
}
