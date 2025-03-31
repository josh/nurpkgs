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
    version = "0-unstable-2025-03-31";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "c5c0736997b65859fd58238851675b15afb679db";
      hash = "sha256-FA5v8XaF+jtNuj5gttniFvjaX+Wg+qhSs9+Ccg73f3I=";
    };

    vendorHash = "sha256-IbKHyumasjXU06jNdGMzl8Q9cSGvm2i0stVs6AMzMAE=";

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
