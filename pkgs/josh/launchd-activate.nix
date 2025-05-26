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
  version = "0.1.0-unstable-2025-05-14";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "launchd-activate";
    rev = "07eeaeba631cde7c83327d07c445f4e499da0a34";
    hash = "sha256-3q9xw9HV8PqAzePT3lnBrpo/q8IPYnyc29vVG6jnU34=";
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
