{
  lib,
  fetchFromGitHub,
  swiftPackages,
  nix-update-script,
}:
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "wezterm-tabline";
  version = ".1.5.0";

  src = fetchFromGitHub {
    owner = "michaelbrusegard";
    repo = "tabline.wez";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Buey1YzN/VHYfOtA7/Fu09l5GooXzbQUW9wqGTSemg=";
  };

  installPhase = ''
    cp -R $src $out
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "A versatile and easy to use tab-bar written in Lua";
    homepage = "https://github.com/michaelbrusegard/tabline.wez";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
