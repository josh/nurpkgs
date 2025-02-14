{
  runCommand,
  python3Packages,
  nur,
}:
let
  source = nur.repos.josh.mcp-servers-source;

  mcp-server-time = python3Packages.buildPythonPackage rec {
    pname = "mcp-server-time";
    inherit (source) version;
    pyproject = true;

    src = source;
    sourceRoot = "${source.name}/src/time";

    build-system = [ python3Packages.hatchling ];

    dependencies = [
      python3Packages.mcp
      python3Packages.tzdata
    ];

    meta = source.meta // {
      description = "A Model Context Protocol server providing tools for time queries and timezone conversions for LLMs";
      homepage = "https://github.com/modelcontextprotocol/servers/tree/main/src/time";
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
