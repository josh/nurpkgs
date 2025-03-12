{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
    hash = "sha256-1xZhQR1BhH2eqax0swlNtnPWIEUTxSOab6sQ3Fv9WQA=";
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
