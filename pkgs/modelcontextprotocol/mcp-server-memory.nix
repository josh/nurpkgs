{ nur, runCommand }:
nur.repos.josh.nodePackages."@modelcontextprotocol/server-memory".overrideAttrs (
  finalAttrs: _previousAttrs: {
    pname = "mcp-server-memory";
    name = "mcp-server-memory-${finalAttrs.version}";

    meta.mainProgram = "mcp-server-memory";
  }
)
