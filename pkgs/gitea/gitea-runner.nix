{
  lib,
  buildGo127Module,
  fetchFromGitea,
  nix-update-script,
  testers,
}:
buildGo127Module (finalAttrs: {
  pname = "gitea-runner";
  version = "6.1.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YylObTsz8+AGavmv4OY8Q6xYiuuvYxxYV/IOg35aJEc=";
  };

  vendorHash = "sha256-AAuc045FprbFkkSl35TbJY5uudRSfaboUzII4YQDtCo=";

  env.CGO_ENABLED = 0;
  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/runner/internal/pkg/ver.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/runner $out/bin/gitea-runner
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Runner for Gitea Actions";
    homepage = "https://gitea.com/gitea/runner";
    changelog = "https://gitea.com/gitea/runner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gitea-runner";
  };
})
