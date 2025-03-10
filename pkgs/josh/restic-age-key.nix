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
    version = "0-unstable-2025-03-09";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "de777d388ecd500ca84e21f784ef8007fc716fe2";
      hash = "sha256-z/mbuYKmYKUsFgzVj6LZZja/OM5RI2h4PGITmWx0qL4=";
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
  finalAttrs: _previousAttrs:
  let
    restic-age-key = finalAttrs.finalPackage;
  in
  {
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
