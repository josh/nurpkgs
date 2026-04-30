{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://victoriametrics.github.io/helm-charts";
  chart = "victoria-logs-collector";
  version = "0.3.3";
  sha256 = "sha256-jdVMdGKfQQjh/FfiMG6cgeJ9p0ZyA/Dv6JcA9gmV2ps=";
  helmTestValues = {
    remoteWrite = [
      { url = "http://localhost:9428"; }
    ];
  };
}
