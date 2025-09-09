{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "ts-acl-hosts-gen";
  version = "0.3.0-unstable-2025-09-08";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "ts-acl-hosts-gen";
    rev = "310b690057367314185716448f5d49afd9757de4";
    hash = "sha256-g/HZXSd8Jts+uKv34QJdI4C+AS9WkRZsqKkjQzmiOgg=";
  };

  vendorHash = "sha256-VFOJ/mWHR7Y4pcjkewYH1/Heg1YqerluUq9SXkGIRRQ=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help =
      runCommand "test-ts-acl-hosts-gen-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          ts-acl-hosts-gen --help
          touch $out
        '';
  };

  meta = {
    description = "Generate Tailscale hosts policy from existing nodes";
    homepage = "https://github.com/josh/ts-acl-hosts-gen";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "ts-acl-hosts-gen";
  };
})
