{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-collector";
  version = "0.3.1";
  sha256 = "sha256-SIGgk+5kbRdEMxP98fKKfbnnLgBAaGefuoyk/CAv5Hs=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428"; }
    ];
  };
}
