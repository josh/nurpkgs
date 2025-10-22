{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "tokyonight-extras";
  version = "4.13.0-unstable-2025-10-22";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "8734a4e9a9b03549337faf5a86637abd5e16721e";
    hash = "sha256-uleLfq8Ynj7jd64JXvgeXd/7JdVsCgNka/URTystnug=";
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
