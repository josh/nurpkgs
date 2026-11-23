{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "tmdb-upcoming-feeds";
  version = "0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tmdb-upcoming-feeds";
    rev = "0cd36c480174d9e4d1f523dac620c09389ea60ae";
    hash = "sha256-zZ4XARX30+gqQekqDLmP7+0/I2eA8N4bHCqIWVruEuw=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help =
      runCommand "test-tmdb-upcoming-feeds-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          tmdb-upcoming-feeds --help 2>&1 | grep -- -api-url
          touch $out
        '';
  };

  meta = {
    description = "JSON feeds for upcoming movies and TV shows";
    homepage = "https://github.com/josh/tmdb-upcoming-feeds";
    license = lib.licenses.mit;
    mainProgram = "tmdb-upcoming-feeds";
  };
})
