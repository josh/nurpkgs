{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "modelcontextprotocol-source";
  version = src.tag;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "servers";
    tag = "2025.5.12";
    hash = "sha256-wBXyljj9Wqro/BEdl+qa60GUzdRIJV1FLfbu8eayW1Y=";
  };

  __structuredAttrs = true;

  buildCommand = ''
    cp -r $src $out
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Model Context Protocol Servers";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
