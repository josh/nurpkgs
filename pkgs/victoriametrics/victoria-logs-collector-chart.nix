{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-collector";
  version = "0.3.0";
  sha256 = "sha256-kepiKw7pke754Y2B85rG2nVNE2dugw8Of31NfP4JnWE=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428"; }
    ];
  };
}
