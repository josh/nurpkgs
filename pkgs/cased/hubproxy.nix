{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "hubproxy";
  version = "1.0.0-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "cased";
    repo = "hubproxy";
    rev = "48698ad20df97441ee65c8388f4cdc3a3b6bfdb1";
    hash = "sha256-s3vHbOrSPWRrFoAQgeJQ+KEVGLST6zv2SdZfR9oDolo=";
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
