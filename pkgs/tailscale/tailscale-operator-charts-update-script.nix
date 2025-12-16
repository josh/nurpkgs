{
  lib,
  writeShellApplication,
  coreutils,
  curl,
  git,
  gnused,
  nix,
  yq,
}:
writeShellApplication {
  name = "tailscale-operator-charts-update-script";
  runtimeInputs = [
    coreutils
    curl
    git
    gnused
    nix
    yq
  ];
  text = ''
    index_path=$(mktemp --suffix=.yaml)
    curl --silent --show-error --fail https://pkgs.tailscale.com/helmcharts/index.yaml --output "$index_path"
    version=$(yq --raw-output '.entries["tailscale-operator"][0].version' "$index_path")
    url=$(yq --raw-output '.entries["tailscale-operator"][0] | "https://pkgs.tailscale.com/helmcharts/\(.urls[0])"' "$index_path")
    sha256=$(nix-prefetch-url --unpack "$url")
    filename=pkgs/tailscale/tailscale-operator-charts.nix
    sed -i "s|version = \".*\";|version = \"$version\";|" "$filename"
    sed -i "s|url = \".*\";|url = \"$url\";|" "$filename"
    sed -i "s|sha256 = \".*\";|sha256 = \"$sha256\";|" "$filename"
    git add "$filename"
    git commit --message "tailscale-operator-charts: $version" || true
  '';
  meta = {
    platforms = lib.platforms.all;
  };
}
