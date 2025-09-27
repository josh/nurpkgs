{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "4.13.0-unstable-2025-09-27";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "4d159616aee17796c2c94d2f5f87d2ee1a3f67c7";
    hash = "sha256-0DRh/Lm8X8LBUa5gb5ZpgeTz61LeZjbPsQEy+t6J864=";
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
