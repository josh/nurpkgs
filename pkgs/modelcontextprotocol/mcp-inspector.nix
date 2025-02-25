{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/inspector".overrideAttrs (
  finalAttrs: _previousAttrs: {
    name = "mcp-inspector-${finalAttrs.version}";
    pname = "mcp-inspector";
    meta.mainProgram = "mcp-inspector";
  }
)
