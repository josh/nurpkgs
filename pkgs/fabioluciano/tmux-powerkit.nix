{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-powerkit";
  rtpFilePath = "tmux-powerkit.tmux";
  version = "5.28.0";

  src = fetchFromGitHub {
    owner = "fabioluciano";
    repo = "tmux-powerkit";
    tag = "v${version}";
    hash = "sha256-5RmLJ+F/vSEUf7IKiWrwqf/CK4z0+W6f8mzVuHf8170=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/fabioluciano/tmux-powerkit";
    description = "A powerful, modular tmux status bar framework";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
