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
    version = "0.3.0-unstable-2025-02-16";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "age-plugin-tpm";
      rev = "3ff950ea9570396ee9b993104322c9150594d01e";
      hash = "sha256-qBXiFl5cQIF80VxP0ryixYO3leZz26CpEc2WEZ3Ti8s=";
    };
    vendorHash = "sha256-VEx6qP02QcwETOQUkMsrqVb+cOElceXcTDaUr480ngs=";

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
