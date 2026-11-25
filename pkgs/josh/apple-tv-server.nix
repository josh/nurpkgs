{
  lib,
  swiftPackages,
  fetchFromGitHub,
  swift,
  swiftpm,
  nix-update-script,
  runCommand,
}:
swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "apple-tv-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "apple-tv-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CdD2R+UDDtUbT9ya7GR8JvyFZNcRQHjwQeZGK01JoIs=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  swiftpmDeps = swiftPackages.fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gwcihDUxqP9FLA7gjVBATOCI8xX02kOKLwqKGnhrsF8=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/release/apple-tv-server $out/bin/apple-tv-server
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help =
      runCommand "test-apple-tv-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          apple-tv-server --help
          touch $out
        '';
  };

  meta = {
    description = "macOS TV server with GraphQL, MCP, and metrics";
    homepage = "https://github.com/josh/apple-tv-server";
    license = lib.licenses.mit;
    mainProgram = "apple-tv-server";
    platforms = lib.platforms.darwin;
    broken = lib.strings.versionOlder swift.version "6.2";
  };
})
