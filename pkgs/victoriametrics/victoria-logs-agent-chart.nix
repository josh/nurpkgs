{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.2.2";
  sha256 = "sha256-b97MLTaJ2zuAlFYQBiPqWp7xzPGLSAGfAzdvSTsQLSk=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
