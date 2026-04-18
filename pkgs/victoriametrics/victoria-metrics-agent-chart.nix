{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-metrics-agent";
  version = "0.36.0";
  sha256 = "sha256-R5q6w0czvQ7fMWEL3LY4cfLjK5Mr4fCF9MnUpflbm5w=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:8428/api/v1/write"; }
    ];
  };
}
