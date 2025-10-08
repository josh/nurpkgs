{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "4.13.0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "00d92e6009671493fceeb0e4baf644f5b983e6e4";
    hash = "sha256-u+w2kaMDdc3cYdS2JTtIqTsE0KtoinYqZ6mXTbBNi84=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/tokyonight
    cp -R ./extras/* $out/share/tokyonight/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Provides TokyoNight extras for numerous other applications";
    homepage = "https://github.com/folke/tokyonight.nvim";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
