{
  lib,
  swiftPackages,

  fetchFromGitHub,

  sqlite,
  swift,
  swiftpm,

  nix-update-script,
  runCommand,
  writeText,
}:
let
  # nixpkgs' Apple SDK ships SQLite3.modulemap without sqlite3.h or libsqlite3.
  sqliteModuleMap = writeText "CSQLite.modulemap" ''
    module CSQLite [system] {
      header "${sqlite.dev}/include/sqlite3.h"
      link "sqlite3"
      export *
    }
  '';
in
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "gametrack-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gametrack-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kZgDus2+vTzqsqIqE5OBUKI9wUkW2oi+7kZgnulhy6M=";
  };

  postPatch = ''
    grep -rlF "import SQLite3" Sources | while IFS= read -r f; do
      substituteInPlace "$f" --replace-fail "import SQLite3" "import CSQLite"
    done
    grep -rqF "import CSQLite" Sources
    ! grep -rqF "import SQLite3" Sources
  '';

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    sqlite
  ];

  swiftpmDeps = swiftPackages.fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gwcihDUxqP9FLA7gjVBATOCI8xX02kOKLwqKGnhrsF8=";
  };

  swiftpmFlags = [
    "-Xcc"
    "-fmodule-map-file=${sqliteModuleMap}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/gametrack-server $out/bin/gametrack-server
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help =
      runCommand "test-gametrack-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          gametrack-server --help
          touch $out
        '';
  };

  meta = {
    description = "GameTrack server with GraphQL, MCP, and metrics";
    homepage = "https://github.com/josh/gametrack-server";
    license = lib.licenses.mit;
    mainProgram = "gametrack-server";
    platforms = lib.platforms.darwin;
    broken = lib.strings.versionOlder swift.version "6.2";
  };
})
