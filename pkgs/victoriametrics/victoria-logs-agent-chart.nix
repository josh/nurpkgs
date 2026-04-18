{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.1.0";
  sha256 = "sha256-SRJSC8xHsDzxLGYRAZT6+fzr7qLC7SnuCtK8aIvhQcQ=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
