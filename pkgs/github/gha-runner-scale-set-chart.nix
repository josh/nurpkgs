{ nur }:
nur.repos.josh.fetchhelm {
  url = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set";
  chart = "gha-runner-scale-set";
  version = "0.14.1";
  sha256 = "sha256-5CQXwssMOEnRFM3SbHKicOjZ3Kf2+whLJzrLw2I1DOY=";
  helmTestValues = {
    controllerServiceAccount.name = "test";
    controllerServiceAccount.namespace = "default";
    githubConfigUrl = "https://github.com/test/test";
    githubConfigSecret.github_token = "test";
  };
}
