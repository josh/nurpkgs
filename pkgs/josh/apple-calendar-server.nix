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
  pname = "apple-calendar-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "apple-calendar-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v/6LuPwbW70dcvvOjb/a7UafYhZA+9TCDpOiGI9jKeY=";
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
    install -Dm755 .build/release/apple-calendar-server $out/bin/apple-calendar-server
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    help =
      runCommand "test-apple-calendar-server-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          apple-calendar-server --help
          touch $out
        '';
  };

  meta = {
    description = "Apple Calendar server with GraphQL, MCP, and metrics";
    homepage = "https://github.com/josh/apple-calendar-server";
    license = lib.licenses.mit;
    mainProgram = "apple-calendar-server";
    platforms = lib.platforms.darwin;
    broken = lib.strings.versionOlder swift.version "6.2";
  };
})
