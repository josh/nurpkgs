{ nur, runCommand }:
nur.repos.josh.nodePackages."@anthropic-ai/claude-code".overrideAttrs (
  finalAttrs: _previousAttrs: {
    name = "claude-code-${finalAttrs.version}";
    pname = "claude-code";
    meta.mainProgram = "claude";
  }
)
