{
  lib,
  swiftPackages,

  fetchFromGitHub,

  sqlite,
  swift,
  swiftpm,

  nix-update-script,
  runCommand,
}:
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "gametrack-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "gametrack-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Comk56PNHiR49akiN262kILlLz1W/EZZhGdhJid5LHk=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  # The package's CSQLite module includes <sqlite3.h>; nixpkgs' Apple SDK has none.
  buildInputs = [
    sqlite
  ];

  swiftpmDeps = swiftPackages.fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gwcihDUxqP9FLA7gjVBATOCI8xX02kOKLwqKGnhrsF8=";
  };

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
