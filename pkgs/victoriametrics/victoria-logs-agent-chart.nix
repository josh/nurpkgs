{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.1.2";
  sha256 = "sha256-aAZAsfzKckkMNvfe7FJi0156Rnj7SZMrwN8hUyoXSec=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
