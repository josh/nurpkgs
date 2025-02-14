{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/inspector".overrideAttrs (
  _finalAttrs: _previousAttrs: {
    meta.mainProgram = "mcp-inspector";
  }
)
