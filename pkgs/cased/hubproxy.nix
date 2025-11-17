{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "hubproxy";
  version = "1.0.0-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "cased";
    repo = "hubproxy";
    rev = "0fd37b6f71a3b2cb8dbe91ae7e6a0bdb5dc55aa7";
    hash = "sha256-fp8Z8EK3UNxHKnQRruid5+kP+MUkgiIJy8P0Sk2pBKk=";
  };

  vendorHash = "sha256-xvccyZEIfKh/y1IVz5THcnrvaZ2f01KKk9lI9q2JkOI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help = runCommand "test-hubproxy-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      hubproxy --help
      touch $out
    '';
  };

  meta = {
    description = "A proxy for better github webhooks";
    homepage = "https://github.com/cased/hubproxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "hubproxy";
  };
})
