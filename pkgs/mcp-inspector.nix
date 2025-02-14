{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/inspector".overrideAttrs (
  finalAttrs: _previousAttrs: {
    meta.mainProgram = "mcp-inspector";
  }
)
