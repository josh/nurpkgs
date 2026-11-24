{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "tmdb-upcoming-feeds";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "tmdb-upcoming-feeds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WJumiL7XrDGiDn0QmxbfWOj5/IneFtPP3YaEbcQSwF0=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

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
