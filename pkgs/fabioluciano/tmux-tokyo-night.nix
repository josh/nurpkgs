{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-tokyo-night";
  rtpFilePath = "tmux-tokyo-night.tmux";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "fabioluciano";
    repo = "tmux-tokyo-night";
    tag = "v${version}";
    hash = "sha256-DEQj1rZfvqKXYYi0bS6tdvGJLYVSmoCRfBVPg0Rbkp0=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/fabioluciano/tmux-tokyo-night";
    description = "A Tokyo Night tmux theme directly inspired from Tokyo Night vim theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
