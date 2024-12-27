# See <https://github.com/josh/systemd-age-creds/blob/main/nix/systemd-age-creds.nix>
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  age,
}:
buildGoModule rec {
  pname = "systemd-age-creds";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "systemd-age-creds";
    rev = "c9fdc1dc9519fbf4427e17355fc07da1ead01619";
    hash = "sha256-8aerJoO+oyXkkRGUIT1jH1OaPQjH/XmHcr0G/lEhJgQ=";
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
}
