{
  lib,
  fetchFromGitHub,
  writeTextFile,
  runCommand,
  sqlite,
  swiftPackages,
  swift,
  swiftpm,
  swiftpm2nix,
  nix-update-script,
}:
let
  generated = swiftpm2nix.helpers ./tccpolicy;
  sqliteModuleMap = writeTextFile {
    name = "CSQLite.modulemap";
    text = ''
      module CSQLite [system] {
        header "${sqlite.dev}/include/sqlite3.h"
        link "sqlite3"
        export *
      }
    '';
  };
in
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "tccpolicy";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tccpolicy";
    rev = "d2a8b75f6c8e6be6f97fdf576764474e5dfa0b9c";
    hash = "sha256-5hMgkAYQ95+xdFyVzq0bU857ovEoGkH/TX5BkOfC9Dk=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    sqlite
  ];

  configurePhase = generated.configure;

  postPatch = ''
    substituteInPlace Sources/**/*.swift \
      --replace "import SQLite3" "import CSQLite"
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
