{
  lib,
  # age,
  age-plugin-tpm',
  age-plugin-tpm,
  fetchFromGitHub,
  runCommand,
}:
age-plugin-tpm'.overrideAttrs (_oldAttrs: {
  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    rev = "5dedd8a6a240ef68851884fe850293e3cc954ac6";
    hash = "sha256-N6Rsnh5V90SCGO0dd6q5xp7k168PDtX3YNdXF4gLDgI=";
  };
  vendorHash = "sha256-qNSQV8GOPdKSzCWUb5ZmXPUb3V6Kgq7w84Tj5zfyLQ4=";

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;

  passthru.tests = {
    help =
      runCommand "test-age-plugin-tpm-help"
        {
          nativeBuildInputs = [ age-plugin-tpm ];
        }
        ''
          age-plugin-tpm --help
          touch $out
        '';

    # encrypt =
    #   runCommand "test-age-plugin-tpm-encrypt"
    #     {
    #       nativeBuildInputs = [
    #         age
    #         age-plugin-tpm
    #       ];
    #     }
    #     ''
    #       echo "Hello World" | age --encrypt \
    #         --recipient "age1tpm1syqqqpqrtxsnkkqlmu505zzrq439hetls4qwwmyhsv8dgjhksvtewvx29lxs7s68qy" \
    #         --output "$out"
    #     '';
  };
})
