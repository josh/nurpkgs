{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "4.14.1-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "b13cfc1286d2aa8bda6ce137b79e857d5a3d5739";
    hash = "sha256-310tJN2Pl5rjyhQoSMYAaoJCNu8501Pxrl5MuxuC2io=";
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
