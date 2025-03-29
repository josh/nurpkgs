{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "nixmcp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "nixmcp";
    tag = "v${version}";
    hash = "sha256-UOMzvkEvXAMYnZTxLAjas3IcEQxRf2pNgG5LyPi9jS0=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.mcp
    python3Packages.requests
    python3Packages.python-dotenv
    python3Packages.beautifulsoup4
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Model Context Protocol for NixOS resources";
    homepage = "https://github.com/utensils/nixmcp";
    changelog = "https://github.com/utensils/nixmcp/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "nixmcp";
  };
}
