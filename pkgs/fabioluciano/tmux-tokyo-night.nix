{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-tokyo-night";
  rtpFilePath = "tmux-tokyo-night.tmux";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "fabioluciano";
    repo = "tmux-tokyo-night";
    tag = "v${version}";
    hash = "sha256-gUov6xD27XR6YDot89RRo+biC6THORCXJTpOhEV7lVM=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/fabioluciano/tmux-tokyo-night";
    description = "A Tokyo Night tmux theme directly inspired from Tokyo Night vim theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
