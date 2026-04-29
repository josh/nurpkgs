{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "ghostty-theme-icons";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "jasonlong";
    repo = "ghostty-theme-icons";
    rev = "4bfd6c552694d51f9a840c853691c62716359f9d";
    hash = "sha256-BLZ+L/4cy1Sbq0cG2wzCpPW4zhcrxp18BCskJo/YKSg=";
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
