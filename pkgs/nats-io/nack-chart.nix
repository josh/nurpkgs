{ nur }:
let
  chart = nur.repos.josh.fetchhelm {
    url = "https://nats-io.github.io/k8s/helm/charts";
    chart = "nack";
    version = "0.31.1";
    sha256 = "sha256-3e/WqvdTAWsSCQ2m63OjoWPa6+bNGEJbWpKiU4mMlRI=";
  };
in
chart.overrideAttrs (oldAttrs: {
  passthru = builtins.removeAttrs oldAttrs.passthru [ "updateScript" ];
})
