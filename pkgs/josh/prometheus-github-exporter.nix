{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  testers,
}:
let
  prometheus-github-exporter = buildGoModule {
    pname = "prometheus-github-exporter";
    version = "0.1.0-unstable-2025-03-04";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "github_exporter";
      rev = "295251ca5a757207cf425b546d8cd3146e8237f6";
      hash = "sha256-mOVms+UMipYna2t0TTtwzxTbS91Nut+aduNG2aOQlBQ=";
    };

    vendorHash = "sha256-AQUcLQcn58llXuJeKDtuHWrXgdovbAyBaHdhnoPfguw=";

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    meta = {
      description = "Prometheus exporter for GitHub metrics";
      homepage = "https://github.com/josh/github_exporter";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      mainProgram = "github_exporter";
    };
  };
in
prometheus-github-exporter.overrideAttrs (
  finalAttrs: _previousAttrs:
  let
    prometheus-github-exporter = finalAttrs.finalPackage;
    version-parts = lib.versions.splitVersion finalAttrs.version;
    stable-version = "${builtins.elemAt version-parts 0}.${builtins.elemAt version-parts 1}.${builtins.elemAt version-parts 2}";
  in
  {
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      version = testers.testVersion {
        package = prometheus-github-exporter;
        version = stable-version;
      };

      help =
        runCommand "test-prometheus-github-exporter-help"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ prometheus-github-exporter ];
          }
          ''
            github_exporter --help
            touch $out
          '';
    };
  }
)
