{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-powerkit";
  rtpFilePath = "tmux-powerkit.tmux";
  version = "5.23.0";

  src = fetchFromGitHub {
    owner = "fabioluciano";
    repo = "tmux-powerkit";
    tag = "v${version}";
    hash = "sha256-u4CygpWtwZXOCJI4uhN9qvj2jSsjWsxQBG+0ty8M4iY=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/fabioluciano/tmux-powerkit";
    description = "A powerful, modular tmux status bar framework";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
