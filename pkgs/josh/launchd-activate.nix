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
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "launchd-activate";
    rev = "8f495c14ae835d3676a33b9bd152d6849c0f9ddd";
    hash = "sha256-l8iOgeaPC3rqmprDdOsEskiB6waNA2DGUyGBmYSpoZ4=";
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
