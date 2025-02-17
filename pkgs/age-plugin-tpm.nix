{
  lib,
  fetchFromGitHub,
  runCommand,
  age,
  age-plugin-tpm',
}:
age-plugin-tpm'.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "0.3.0";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "age-plugin-tpm";
      rev = "2c8f8e818a3d5a2d9bc8a175daad12a0dfce91e8";
      hash = "sha256-yr1PSSmcUoOrQ8VMQEoaCLNvDO+3+6N7XXdNUyYVz9M=";
    };

    vendorHash = "sha256-VEx6qP02QcwETOQUkMsrqVb+cOElceXcTDaUr480ngs=";

    nativeCheckInputs = previousAttrs.nativeCheckInputs ++ [
      age
    ];

    meta = {
      mainProgram = "age-plugin-tpm";
      platforms = lib.platforms.all;
      position = "${./age-plugin-tpm.nix}:12";
    };

    passthru.updateScriptVersion = "stable";

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
