{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.1.3";
  sha256 = "sha256-LxvsXQ23Snidg+2vj/owAuEK5JvER+rft3LPQTIf/d8=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
