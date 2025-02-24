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
    version = "0.0.0";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "restic-age-key";
      rev = "29e945f1386b0f45808e46830baa350a6307cc4f";
      hash = "sha256-g600KFRe8gywHoYu0erdI7k83WKajVKtfLSH8d82nk4=";
    };

    vendorHash = "sha256-LlU2QYt/d1gP2tTMR5N7qzEUQ8KCezbUoVApbE6r8Bg=";

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
    passthru.updateScriptVersion = "branch";
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
