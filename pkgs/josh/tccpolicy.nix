{
  lib,
  writers,
  writeText,
  fetchFromGitHub,
  runCommand,
  swiftPackages,
  swift,
  swiftpm,
  sqlite,
  nix-update-script,
}:
let
  swift-argument-parser = fetchFromGitHub {
    owner = "apple";
    repo = "swift-argument-parser";
    rev = "41982a3656a71c768319979febd796c6fd111d5c";
    sha256 = "sha256-TRaJG8ikzuQQjH3ERfuYNKPty3qI3ziC/9v96pvlvRs=";
  };

  workspaceState = writers.writeJSON "workspace-state.json" {
    object = {
      artifacts = [ ];
      dependencies = [
        {
          basedOn = null;
          packageRef = {
            identity = "swift-argument-parser";
            kind = "remoteSourceControl";
            location = "https://github.com/apple/swift-argument-parser";
            name = "swift-argument-parser";
          };
          state = {
            checkoutState = {
              revision = "41982a3656a71c768319979febd796c6fd111d5c";
              version = "1.5.0";
            };
            name = "sourceControlCheckout";
          };
          subpath = "swift-argument-parser";
        }
      ];
    };
    version = 6;
  };

  sqliteModuleMap = writeText "CSQLite.modulemap" ''
    module CSQLite [system] {
      header "${sqlite.dev}/include/sqlite3.h"
      link "sqlite3"
      export *
    }
  '';
in
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "tccpolicy";
  version = "0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tccpolicy";
    rev = "14a81534e7271af9ca8d172fa483c6e2d36e9bac";
    hash = "sha256-iOMpmiYm/pmAXr4Tur9OKf5aJXfAIiJN60wtWk/O2JU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    sqlite
  ];

  postPatch = ''
    substituteInPlace Sources/**/*.swift \
      --replace "import SQLite3" "import CSQLite"
  '';

  configurePhase = ''
    mkdir -p .build/checkouts
    install -m 0600 ${workspaceState} .build/workspace-state.json
    ln -s ${swift-argument-parser} .build/checkouts/swift-argument-parser
  '';

  swiftpmFlags = [
    "-Xcc"
    "-fmodule-map-file=${sqliteModuleMap}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/tccpolicy $out/bin/tccpolicy
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help =
      runCommand "test-tccpolicy-help"
        {
          __structuredAttrs = true;
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          tccpolicy --help >$out
        '';
  };

  meta = {
    description = "Manage macOS TCC database declaratively";
    homepage = "https://github.com/josh/tccpolicy";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "tccpolicy";
  };
})
