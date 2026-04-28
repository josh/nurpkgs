{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-collector";
  version = "0.3.2";
  sha256 = "sha256-oBLTclbC7aYIpc9LZ/1T7567t299tpR9hswkVwMOC1s=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428"; }
    ];
  };
}
