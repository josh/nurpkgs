{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
}:
let
  kit = python3Packages.buildPythonApplication rec {
    pname = "cased-kit";
    version = "1.2.2";

    src = fetchFromGitHub {
      owner = "cased";
      repo = "kit";
      rev = "v${version}";
      hash = "sha256-rVqjVq/oT1ZoJwmSQ9e8n6BW+adoVKgaEnFSAHabn9M=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
      anthropic
      click
      fastapi
      google-genai
      mcp
      mypy
      numpy
      openai
      pathspec
      pytest
      python-hcl2
      pyyaml
      redis
      requests
      ruff
      tiktoken
      tree-sitter-language-pack
      typer
      types-pyyaml
      types-requests
      uvicorn
    ];

    meta = {
      description = "The toolkit for codebase mapping, symbol extraction, and many kinds of code search";
      homepage = "https://github.com/cased/kit";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "kit";
    };
  };
in
kit.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    kit = finalAttrs.finalPackage;
  in
  {
    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

      tests = {
        help = runCommand "test-kit-help" { nativeBuildInputs = [ kit ]; } ''
          kit --help
          touch $out
        '';
      };
    };
  }
)
