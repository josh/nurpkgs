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
    version = "0.2.0-unstable-2025-02-15";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "age-plugin-tpm";
      rev = "7afaac49a9a3c7df2d8bd9ac6aaef8aed175fd11";
      hash = "sha256-UNy7lsqvqZ6JNPA2INpKtUq1Jg439zw3/z9l1+N2AfY=";
    };
    vendorHash = "sha256-qNSQV8GOPdKSzCWUb5ZmXPUb3V6Kgq7w84Tj5zfyLQ4=";

    meta = {
      mainProgram = "age-plugin-tpm";
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      position = "${./age-plugin-tpm.nix}:12";
    };

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
