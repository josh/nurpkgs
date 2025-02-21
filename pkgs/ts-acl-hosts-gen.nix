{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
let
  ts-acl-hosts-gen = buildGoModule {
    pname = "ts-acl-hosts-gen";
    version = "0.1.0-unstable-2025-02-21";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "ts-acl-hosts-gen";
      rev = "07c4fafa164f04f8ba2fe92290d8385dcb4a24a1";
      hash = "sha256-spv8yKhgOQ/5ycX6mzZSWOe7uoU0Yg5Ko2zPK9IzHE0=";
    };

    vendorHash = "sha256-bAMm3+UaDoIvrwlBM2kveOt/clAyfcxkDYkqMD5IfWU=";

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    meta = {
      description = "Generate Tailscale hosts policy from existing nodes";
      homepage = "https://github.com/josh/ts-acl-hosts-gen";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "ts-acl-hosts-gen";
    };
  };
in
ts-acl-hosts-gen.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    ts-acl-hosts-gen = finalAttrs.finalPackage;
  in
  {
    passthru.updateScriptVersion = "branch";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      help =
        runCommand "test-ts-acl-hosts-gen-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ ts-acl-hosts-gen ];
          }
          ''
            ts-acl-hosts-gen --help
            touch $out
          '';
    };
  }
)
