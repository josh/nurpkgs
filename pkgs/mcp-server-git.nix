{
  lib,
  fetchFromGitHub,
  runCommand,
  python3Packages,
  nix-update-script,
}:
let
  mcp-server-git = python3Packages.buildPythonPackage rec {
    pname = "mcp-server-git";
    version = "2025.1.17";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "modelcontextprotocol";
      repo = "servers";
      rev = version;
      hash = "sha256-qJQWSPYXI4hA/NMSwb6eiEAOPAc2yRfk9hf7J9wdqp4=";
    };

    sourceRoot = "source/src/git";

    build-system = [ python3Packages.hatchling ];

    dependencies = [
      python3Packages.click
      python3Packages.gitpython
      python3Packages.mcp
    ];

    meta = {
      description = "A Model Context Protocol server providing tools to read, search, and manipulate Git repositories programmatically via LLMs";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/git";
      changelog = "https://github.com/modelcontextprotocol/servers/releases/tag/${version}";
      license = lib.licenses.mit;
      mainProgram = "mcp-server-git";
    };
  };
in
mcp-server-git.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    mcp-server-git = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "stable";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

    passthru.tests = {
      help =
        runCommand "test-mcp-server-git-help"
          {
            nativeBuildInputs = [ mcp-server-git ];
          }
          ''
            mcp-server-git --help
            touch $out
          '';
    };
  }
)
