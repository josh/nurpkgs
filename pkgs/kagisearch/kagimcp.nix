{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  nur,
}:
python3Packages.buildPythonPackage rec {
  pname = "kagimcp";
  version = "0-unstable-2025-04-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kagisearch";
    repo = "kagimcp";
    rev = "599e22ac84d0b83d2c9964513477357901f67893";
    hash = "sha256-Y9nyYj6qGFnt/PlwAbiVV9zR4JthqKoxrSvNwBxzpds=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'pydantic~=2.10.3' 'pydantic'
  '';

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    nur.repos.josh.kagiapi
    python3Packages.mcp
    python3Packages.pydantic
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Model Context Protocol (MCP) server for Kagi search & other tools";
    homepage = "https://github.com/kagisearch/kagimcp";
    license = lib.licenses.mit;
    mainProgram = "kagimcp";
  };
}
