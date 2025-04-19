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
    tag = "2025.4.8";
    hash = "sha256-QrG0Bbl4s3Ln9QTSc+3aS0ue1HGT8fk/DVH2r8jx1Mo=";
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
