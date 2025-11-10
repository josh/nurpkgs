{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "rose-pine-tmtheme";
  version = "0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "tm-theme";
    rev = "4027fadfe8796ba429e32d03e6ada177c934c834";
    hash = "sha256-PfU4QwuE3t6QH1gPwUUKt8DFABJdCAFEz017PubXS10=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rose-pine/tmtheme
    cp ./dist/*.tmTheme $out/share/rose-pine/tmtheme/

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
