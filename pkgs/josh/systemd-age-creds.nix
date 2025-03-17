# See <https://github.com/josh/systemd-age-creds/blob/main/nix/systemd-age-creds.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  age,
  nix-update-script,
  runCommand,
  testers,
}:
let
  systemd-age-creds = buildGoModule rec {
    pname = "systemd-age-creds";
    version = "0.1.0-unstable-2025-03-17";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "systemd-age-creds";
      rev = "077e83fefc7d0c2aaffa6db4fabe47b3585575c7";
      hash = "sha256-Z6BIGlKfZDIE4FMOh3Tq0uMiEtfPoJ56Y8zzBpoKu0o=";
    };

    vendorHash = null;

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
      "-X main.AgeBin=${lib.getExe age}"
    ];

    nativeBuildInputs = [ age ];

    meta = {
      description = "Load age encrypted credentials in systemd units";
      mainProgram = "systemd-age-creds";
      homepage = "https://github.com/josh/systemd-age-creds";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };
in
systemd-age-creds.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    systemd-age-creds = finalAttrs.finalPackage;
    version-parts = lib.versions.splitVersion finalAttrs.version;
    stable-version = "${builtins.elemAt version-parts 0}.${builtins.elemAt version-parts 1}.${builtins.elemAt version-parts 2}";
  in
  {
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      version = testers.testVersion {
        package = systemd-age-creds;
        version = stable-version;
      };

      help =
        runCommand "test-systemd-age-creds-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ systemd-age-creds ];
          }
          ''
            systemd-age-creds --help
            touch $out
          '';
    };
  }
)
