{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rose-pine-tmtheme";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "tm-theme";
    rev = "e89481b166ceafd1d5418021b8775326d0c2c84f";
    hash = "sha256-fKSuwzWqmnEZDO84XdKph5wVMiBlP2EjKSOpc/0T1yw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rose-pine/tmtheme
    cp ./dist/themes/*.tmTheme $out/share/rose-pine/tmtheme/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Soho vibes for TextMate";
    homepage = "https://github.com/rose-pine/tm-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
