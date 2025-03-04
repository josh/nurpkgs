{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  age,
  restic,
}:
let
  restic-age-key = buildGoModule {
    pname = "restic-age-key";
    version = "0-unstable-2025-03-04";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "edf852a06e0f94975797ed9d1b6e515e6140513b";
      hash = "sha256-BFjmD2Hf0zgtWzcJ7IADThxubTpt/HSlUpH+HJ0x7co=";
    };

    vendorHash = "sha256-W1IlUl+s4/wDv4V/EIvo4fmYyNa/CCbIwpcJ5KHmtvk=";

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    nativeCheckInputs = [
      age
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
