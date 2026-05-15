{ nur }:
nur.repos.josh.fetchhelm {
  url = "https://isindir.github.io/sops-secrets-operator/";
  chart = "sops-secrets-operator";
  version = "0.27.0";
  sha256 = "sha256-pfUhIXEhh8oGKONq8a3cTAdxz6QSUTgOtfAFnwPsqRg=";
  helmTestArgs = [
    "--kube-version"
    "1.36.0"
  ];
}
