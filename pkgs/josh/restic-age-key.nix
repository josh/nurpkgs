{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  age,
  jq,
  restic,
}:
let
  restic-age-key = buildGoModule {
    pname = "restic-age-key";
    version = "0-unstable-2025-03-11";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "f533bb47fe39d9c47b1182a17152efa10be491e2";
      hash = "sha256-dCOJfKohsr8kH+QafyyG7S1cfti2mHBQx+Tvjeye6Mo=";
    };

    vendorHash = "sha256-CgAlKL+pdFxIJiQYuK53LN+7wdJXc+8vfTLoHoHD9rA=";

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    nativeCheckInputs = [
      age
      jq
      restic
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
