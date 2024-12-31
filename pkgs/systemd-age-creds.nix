# See <https://github.com/josh/systemd-age-creds/blob/main/nix/systemd-age-creds.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  age,
  nix-update-script,
}:
buildGoModule rec {
  pname = "systemd-age-creds";
  version = "0-unstable-2024-12-30";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "systemd-age-creds";
    rev = "af6fe0b04a1d3c5dbd6e55e70650dfe228fcd37b";
    hash = "sha256-aqLd0vGGfZtR0oInY4g1p4N1QBGXTZHOrOi+lr5Alxg=";
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

  passthru.updateScriptVersion = "branch";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Load age encrypted credentials in systemd units";
    mainProgram = "systemd-age-creds";
    homepage = "https://github.com/josh/systemd-age-creds";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
