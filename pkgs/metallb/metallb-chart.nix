{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://metallb.github.io/metallb/";
  chart = "metallb";
  version = "0.16.0";
  sha256 = "sha256-rbOhBugpWX4ONiAr3EW4UpCUf2QlHJ6WivC6KVzqDqc=";
  helmTestValues = {
    "frr-k8s".prometheus.serviceMonitor.enabled = false;
  };
}
