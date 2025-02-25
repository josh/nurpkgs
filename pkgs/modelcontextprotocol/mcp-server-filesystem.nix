{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/server-filesystem".overrideAttrs (
  finalAttrs: _previousAttrs: {
    name = "mcp-server-filesystem-${finalAttrs.version}";
    pname = "mcp-server-filesystem";
    meta.mainProgram = "mcp-server-filesystem";
  }
)
