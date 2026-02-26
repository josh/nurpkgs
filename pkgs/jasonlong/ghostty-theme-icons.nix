{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "ghostty-theme-icons";
  version = "0-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "jasonlong";
    repo = "ghostty-theme-icons";
    rev = "d8b98862838cceab9b94b48e3d70707645ed4699";
    hash = "sha256-ULly4PCVuRt7nJ7bStnUYPjE8atkqhYD57wNx4qODpU=";
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
