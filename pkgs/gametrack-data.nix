# See <https://github.com/josh/gametrack-data/blob/main/package.nix>
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "gametrack-data";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gametrack-data";
    rev = "v${version}";
    hash = "sha256-N6c72fwSLz5KQ82AW/pDQrBbrD55U4WG5EpGcHzMzrY=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  passthru.updateScriptVersion = "stable";

  meta = {
    description = "Export GameTrack data to CSV";
    homepage = "https://github.com/josh/gametrack-data";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "gametrack-data";
  };
}
