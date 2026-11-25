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
  pname = "apple-contacts-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "apple-contacts-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JUmj6UdRh19wORM/Y4sr1RBZQE7/GjUpyHmfEn11cEA=";
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
    install -Dm755 .build/release/apple-contacts-server $out/bin/apple-contacts-server
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help =
      runCommand "test-apple-contacts-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          apple-contacts-server --help
          touch $out
        '';
  };

  meta = {
    description = "macOS Contacts server with GraphQL, MCP, and metrics";
    homepage = "https://github.com/josh/apple-contacts-server";
    license = lib.licenses.mit;
    mainProgram = "apple-contacts-server";
    platforms = lib.platforms.darwin;
    broken = lib.strings.versionOlder swift.version "6.2";
  };
})
