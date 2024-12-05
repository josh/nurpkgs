{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "macos-defaults";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dsully";
    repo = "macos-defaults";
    rev = version;
    hash = "sha256-dSZjMuw7ott0dgiYo0rqekEvScmrX6iG7xHaPAgo1/E=";
  };

  cargoHash = "sha256-K22IjVYDLDP1qUjESjKk0LEZr198+uWhxBsX8XNIH0Q=";

  doCheck = false;

  meta = {
    description = "A tool for managing macOS defaults declaratively via YAML files.";
    homepage = "https://github.com/dsully/macos-defaults";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "macos-defaults";
  };
}
