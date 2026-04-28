{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-metrics-agent";
  version = "0.38.0";
  sha256 = "sha256-koOsCHBY02FRCfs1iHQnen/7Bi5RY7qyqsrFXgHqya4=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:8428/api/v1/write"; }
    ];
  };
}
