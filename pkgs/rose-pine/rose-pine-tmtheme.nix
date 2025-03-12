{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rose-pine-tmtheme";
  version = "0-unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "tm-theme";
    rev = "45061dc3fda6bd2126305df8fd6c81ef5a0f9c27";
    hash = "sha256-N68TUiNQkyVdgEFQ4EH1PpSAjHCsavha7moXHUg89/w=";
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
