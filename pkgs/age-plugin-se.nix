{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  testers,
  age,
}:
stdenv.mkDerivation {
  pname = "age-plugin-se";
  version = "0.1.4";
  src = fetchurl {
    url = "https://github.com/remko/age-plugin-se/releases/download/v0.1.4/age-plugin-se-v0.1.4-x86_64-linux.tgz";
    sha256 = "sha256-/RRcqJsvSwniPqUO9Fmlxtc36FIDwajv62CTmJmPgdM=";
  };

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
    platforms = [ "x86_64-linux" ];
  };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
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
}
