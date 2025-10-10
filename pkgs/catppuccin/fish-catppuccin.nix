{
  lib,
  fishPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
fishPlugins.buildFishPlugin {
  pname = "fish-catppuccin";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
    hash = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
  };

  preInstall = ''
    mkdir -p $out/share/fish/themes
    cp themes/* $out/share/fish/themes/
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Soothing pastel theme for the Fish Shell";
    homepage = "https://github.com/catppuccin/fish";
    license = lib.licenses.mit;
  };
}
