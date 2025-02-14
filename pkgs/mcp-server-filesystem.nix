{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/server-filesystem".overrideAttrs (
  _finalAttrs: _previousAttrs: {
    meta.mainProgram = "mcp-server-filesystem";
  }
)
