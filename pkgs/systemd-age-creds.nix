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
  version = "0.1.0-unstable-2025-01-01";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "systemd-age-creds";
    rev = "241e5bf8df057a54a21afe7484f0bd70eff33801";
    hash = "sha256-IOXMPo97w6wZ2eMH8NdmsBn6ZClueSx/cjny1F1Iw8E=";
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
