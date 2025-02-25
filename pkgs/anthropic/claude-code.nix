{ nur, runCommand }:
nur.repos.josh.nodePackages."@anthropic-ai/claude-code".overrideAttrs (
  finalAttrs: _previousAttrs: {
    pname = "claude-code";
    name = "claude-code-${finalAttrs.version}";

    meta.mainProgram = "claude";
  }
)
