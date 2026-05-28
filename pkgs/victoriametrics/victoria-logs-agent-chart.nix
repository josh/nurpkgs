{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.2.0";
  sha256 = "sha256-XetUbYOQ1epc6wljpsCmzuo187rpXI5B1STQ8nCeXrw=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
