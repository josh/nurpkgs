{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "catppuccin";
  rtpFilePath = "catppuccin.tmux";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    tag = "v${version}";
    hash = "sha256-aVqh8zP4hwOKJavoV/AoLMP5JTQORCgvwJlGpFxADjk=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/catppuccin/tmux";
    description = "Soothing pastel theme for Tmux!";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
