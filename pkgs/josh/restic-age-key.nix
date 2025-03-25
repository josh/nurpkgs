{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  age,
  jq,
  restic,
  tinyxxd,
}:
let
  restic-age-key = buildGoModule {
    pname = "restic-age-key";
    version = "0-unstable-2025-03-25";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "a4f911cf4afe3ff67e462eb27e2884bd12c91ebd";
      hash = "sha256-AiQp8EEpEtrVBOSwj//A7TF2sek8B5dJTLwCx7hcVW4=";
    };

    vendorHash = "sha256-LxBY+22Q5qHgQmzkS59Ngk2bznhCFAr++SLiCWPTGKE=";

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    nativeCheckInputs = [
      age
      jq
      restic
      tinyxxd
    ];

    meta = {
      description = "Use asymmetric age keys instead of a password on your restic repository";
      homepage = "https://github.com/josh/restic-age-key";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "restic-age-key";
    };
  };
in
restic-age-key.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    restic-age-key = finalAttrs.finalPackage;
  in
  {
    ldflags = previousAttrs.ldflags ++ [
      "-X main.Version=${finalAttrs.version}"
      "-X main.AgeBin=${lib.getExe age}"
    ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      help =
        runCommand "test-restic-age-key-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ restic-age-key ];
          }
          ''
            restic-age-key --help
            touch $out
          '';
    };
  }
)
