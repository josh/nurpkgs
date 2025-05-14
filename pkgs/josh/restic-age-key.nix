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
    version = "0.1.1-unstable-2025-05-14";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "dd69fcaa3f3d07b45e4d722eaa2065b6c65256f0";
      hash = "sha256-nTuU8ppBx4RJhfISwukRv3x9lMCZFclkpbq76tvflas=";
    };

    vendorHash = "sha256-cKa3ov/6aiAxnnbQgDjqiNi1NwZhUsjLIzdkMVj6teU=";

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
