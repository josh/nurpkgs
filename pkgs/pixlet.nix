# Upstream to NixOS/nixpkgs
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libwebp,
  runCommand,
  testers,
  nur,
}:
let
  version = "0.34.0";
in
buildGoModule {
  pname = "pixlet";
  inherit version;

  src = fetchFromGitHub {
    owner = "tidbyt";
    repo = "pixlet";
    rev = "v${version}";
    hash = "sha256-9OXwXrXqgVYnFIqDz0iSE4o9LmWDIPB7kqX9CVNaQZk=";
  };

  vendorHash = "sha256-SbdZylgQJenAAT5kOCPT0mdCs3H/1t1giiiQRB4D0Zo=";

  buildInputs = [ libwebp ];

  CGO_ENABLED = 1;

  ldflags = [
    "-X 'tidbyt.dev/pixlet/cmd.Version=v${version}'"
  ];

  # Disable go tests
  doCheck = false;

  meta = {
    description = "Build apps for pixel-based displays";
    homepage = "https://github.com/tidbyt/pixlet";
    license = lib.licenses.asl20;
    mainPackage = "pixlet";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru.tests =
    let
      inherit (nur.repos.josh) pixlet;
    in
    {
      version = testers.testVersion {
        package = pixlet;
        command = "pixlet version";
        version = "v${pixlet.version}";
      };

      help = runCommand "test-pixlet-help" { nativeBuildInputs = [ pixlet ]; } ''
        pixlet --help
        touch $out
      '';
    };
}
