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
  pname = "launchd-activate";
  version = "0-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "launchd-activate";
    rev = "60b10b25c1b9eb280d69c5c2c136923d8c026960";
    hash = "sha256-DcwOM18f1iNWzZ1htfpd/WoJPjYaRWO0xJYtswzNhE4=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/launchd-activate $out/bin/launchd-activate
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help =
      runCommand "test-launchd-activate-help"
        {
          __structuredAttrs = true;
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          launchd-activate --help
          touch $out
        '';
  };

  meta = {
    description = "Declaratively load and unload launchd agents";
    homepage = "https://github.com/josh/launchd-activate";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "launchd-activate";
  };
})
