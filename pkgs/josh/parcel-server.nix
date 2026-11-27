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
  pname = "parcel-server";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "parcel-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fyV2VxWEbKPidANlm6o5xZY25v49AvPxsSKe3Kzv96M=";
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
    hash = "sha256-uNR/y6m68WrtalN7U+n4U20vmixhRhAPNnUdBjNHIY8=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/parcel-server $out/bin/parcel-server
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help = runCommand "test-parcel-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      parcel-server --help
      touch $out
    '';
  };

  meta = {
    description = "Parcel server with GraphQL, MCP, and metrics";
    homepage = "https://github.com/josh/parcel-server";
    license = lib.licenses.mit;
    mainProgram = "parcel-server";
    platforms = lib.platforms.darwin;
    broken = lib.strings.versionOlder swift.version "6.2";
  };
})
