{
  lib,
  tmuxPlugins,
  fetchFromGitHub,
  nix-update-script,
}:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "catppuccin";
  rtpFilePath = "catppuccin.tmux";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    rev = "2c4cb5a07a3e133ce6d5382db1ab541a0216ddc7";
    hash = "sha256-vBYBvZrMGLpMU059a+Z4SEekWdQD0GrDqBQyqfkEHPg=";
  };

  postInstall = ''
    sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    homepage = "https://github.com/catppuccin/tmux";
    description = "Soothing pastel theme for Tmux!";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
