{
  system,
  lib,
  stdenv,
  fetchurl,
  runCommand,
  testers,
  age,
}:
let
  version = "0.1.4";
  sources = {
    "aarch64-linux" = fetchurl {
      url = "https://github.com/remko/age-plugin-se/releases/download/v0.1.4/age-plugin-se-v0.1.4-aarch64-linux.tgz";
      sha256 = "11hyqakcp3jvr092z61b9sv1bpn088f68bxmigja7w4mb1bar6j5";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/remko/age-plugin-se/releases/download/v0.1.4/age-plugin-se-v0.1.4-x86_64-linux.tgz";
      sha256 = "1lw1iycri4v0xgpsih83abl3gmy6lmcz83m57vi0jjrgkfl5q57x";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "age-plugin-se";
  inherit version;
  src = sources.${system};

  installPhase = ''
    mkdir -p $out/bin
    cp usr/bin/age-plugin-se $out/bin/
  '';

  meta = with lib; {
    description = "Age plugin for Apple's Secure Enclave";
    homepage = "https://github.com/remko/age-plugin-se";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainPackage = "age-plugin-se";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };

    help =
      runCommand "test-age-plugin-se-help"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          age-plugin-se --help
          touch $out
        '';

    encrypt =
      runCommand "test-age-plugin-se-encrypt"
        {
          nativeBuildInputs = [
            age
            finalAttrs.finalPackage
          ];
        }
        ''
          echo "Hello World" | age --encrypt \
            --recipient "age1se1qgg72x2qfk9wg3wh0qg9u0v7l5dkq4jx69fv80p6wdus3ftg6flwg5dz2dp" \
            --armor
          touch $out
        '';
  };
})
