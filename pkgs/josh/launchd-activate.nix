{
  lib,
  swiftPackages,
  fetchFromGitHub,

  coreutils,
  swift,
  swiftpm,

  nix-update-script,
  runCommand,
  testers,
}:
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "launchd-activate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "launchd-activate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UgWS+DEw3s4bJm8wcetwQhHLTM1ossPHUbuNXSDOEZU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = ''
    runHook preConfigure

    rm Sources/launchd-activate/Constants.swift

    cat >Sources/launchd-activate/Constants.swift <<EOF
    let VERSION = "$version"
    let CP_PATH = "${lib.getExe' coreutils "cp"}"
    let LN_PATH = "${lib.getExe' coreutils "ln"}"
    let RM_PATH = "${lib.getExe' coreutils "rm"}"
    let SUDO_PATH = "/usr/bin/sudo"
    let LAUNCHCTL_PATH = "/bin/launchctl"
    EOF

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/launchd-activate $out/bin/launchd-activate
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };

    help =
      runCommand "test-launchd-activate-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
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
