{
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
fetchFromGitHub {
  name = "modelcontextprotocol-source";
  owner = "modelcontextprotocol";
  repo = "servers";
  tag = "2025.1.17";
  hash = "sha256-qJQWSPYXI4hA/NMSwb6eiEAOPAc2yRfk9hf7J9wdqp4=";
  meta = {
    description = "Model Context Protocol Servers";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = lib.licenses.mit;
    available = true;
  };
  passthru.updateScriptVersion = "stable";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };
}
