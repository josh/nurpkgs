{
  lib,
  fetchFromGitHub,
  runCommand,
  python3Packages,
  nix-update-script,
}:
let
  mcp-server-time = python3Packages.buildPythonPackage rec {
    pname = "mcp-server-time";
    version = "2025.1.17";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-qJQWSPYXI4hA/NMSwb6eiEAOPAc2yRfk9hf7J9wdqp4=";
    };

    sourceRoot = "source/src/time";

    build-system = [ python3Packages.hatchling ];

    dependencies = [
      python3Packages.mcp
      python3Packages.tzdata
    ];

    meta = {
      description = "A Model Context Protocol server providing tools for time queries and timezone conversions for LLMs";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/time";
      changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${version}";
      license = lib.licenses.mit;
      mainProgram = "mcp-server-time";
    };
  };
in
mcp-server-time.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    mcp-server-time = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "stable";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

    passthru.tests = {
      help =
        runCommand "test-mcp-server-time-help"
          {
            nativeBuildInputs = [ mcp-server-time ];
          }
          ''
            mcp-server-time --help
            touch $out
          '';
    };
  }
)
