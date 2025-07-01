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
buildGoModule (finalAttrs: {
  pname = "restic-age-key";
  version = "0.1.2-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "restic-age-key";
    rev = "2430f07021e721ee08a25c15221eb5495afe2cf4";
    hash = "sha256-tHJzugMMDHQ0pCdg8Tnto+FktsEMbKMUanaHuKXrPzk=";
  };

  vendorHash = "sha256-cKa3ov/6aiAxnnbQgDjqiNi1NwZhUsjLIzdkMVj6teU=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.AgeBin=${lib.getExe age}"
  ];

  nativeCheckInputs = [
    age
    jq
    restic
    tinyxxd
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help = runCommand "test-restic-age-key-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      restic-age-key --help
      touch $out
    '';
  };

  meta = {
    description = "Use asymmetric age keys instead of a password on your restic repository";
    homepage = "https://github.com/josh/restic-age-key";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "restic-age-key";
  };
})
