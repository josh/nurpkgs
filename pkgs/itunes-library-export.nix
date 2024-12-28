{
  lib,
  fetchFromGitHub,
  runCommand,
  swiftPackages,
  swift,
  swiftpm,
  nix-update-script,
}:
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "itunes-library-export";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "itunes-library-export";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GRNi8FljsgX7iJWLtv1lXtveLFGsxD6SCT/2DJpBh2M=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/itunes-library-export $out/bin/itunes-library-export
    runHook postInstall
  '';

  passthru.updateScriptVersion = "stable";
  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    help =
      runCommand "test-itunes-library-export-help"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          itunes-library-export --help >$out
        '';
  };

  meta = {
    description = "A command line tool to export iTunes Library XML files.";
    homepage = "https://github.com/josh/itunes-library-export";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "itunes-library-export";
  };
})
