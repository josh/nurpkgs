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
    version = "0.1.0-unstable-2025-01-04";

    src = fetchFromGitHub {
      owner = "josh";
      repo = "github_exporter";
      rev = "6593b1935e7bbb816533f052bdaa8fa00580e8a8";
      hash = "sha256-LcurLEZk6NZ/9ET28BMsYftB5RenLchVnW/SUcBYizc=";
    };

    vendorHash = "sha256-RJYQL7XZlfLZBOY8hg8w4yoGRXq9RsLlS6GZWPaDe5Y=";

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
    passthru.updateScriptVersion = "branch";
    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    passthru.tests = {
      version = testers.testVersion {
        package = prometheus-github-exporter;
        version = stable-version;
      };

      help =
        runCommand "test-prometheus-github-exporter-help"
          {
            nativeBuildInputs = [ prometheus-github-exporter ];
          }
          ''
            github_exporter --help
            touch $out
          '';
    };
  }
)
