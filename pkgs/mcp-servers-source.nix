{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  name = "modelcontextprotocol-source";
  version = src.tag;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "2025.2.12";
    hash = "sha256-XKlgTdK3fQ6Z+bB7ZIGHTw8xHW9bT8vp6BFVNspHcd8=";
  };

  buildCommand = ''
    cp -r $src $out
  '';

  meta = {
    description = "Model Context Protocol Servers";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };

  passthru.updateScriptVersion = "stable";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };
}
