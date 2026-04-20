{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-agent";
  version = "0.1.1";
  sha256 = "sha256-4sCLLCZurwEhlS66ib2QhLIdyDoJjsQEak4A8DOqpsk=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428/insert/jsonline"; }
    ];
  };
}
