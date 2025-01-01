# Upstream to NixOS/nixpkgs
# - Waiting for post v0.2.0 tagged release
{
  lib,
  fetchFromGitHub,
  runCommand,
  age,
  age-plugin-tpm',
}:
age-plugin-tpm'.overrideAttrs (
  finalAttrs: _previousAttrs: {
    version = "0.2.0-unstable-2024-06-20";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "age-plugin-tpm";
      rev = "5dedd8a6a240ef68851884fe850293e3cc954ac6";
      hash = "sha256-N6Rsnh5V90SCGO0dd6q5xp7k168PDtX3YNdXF4gLDgI=";
    };
    vendorHash = "sha256-qNSQV8GOPdKSzCWUb5ZmXPUb3V6Kgq7w84Tj5zfyLQ4=";

    meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
    meta.position = "${./age-plugin-tpm.nix}:12";

    passthru.updateScriptVersion = "branch";

    passthru.tests = {
      help =
        runCommand "test-age-plugin-tpm-help"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            age-plugin-tpm --help
            touch $out
          '';

      encrypt =
        runCommand "test-age-plugin-tpm-encrypt"
          {
            nativeBuildInputs = [
              age
              finalAttrs.finalPackage
            ];
          }
          ''
            echo "Hello World" | age --encrypt \
              --recipient "age1tpm1qg86fn5esp30u9h6jy6zvu9gcsvnac09vn8jzjxt8s3qtlcv5h2x287wm36" \
              --armor
            touch $out
          '';
    };
  }
)
