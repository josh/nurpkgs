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
  name = "update-helm-chart-script";

  runtimeInputs = [
    coreutils
    curl
    git
    gnused
    nix
    yq
  ];

  text = ''
    url="$1"
    chart="$2"
    filename="$3"
    [ -n "$UPDATE_NIX_PNAME" ]
    [ -n "$UPDATE_NIX_OLD_VERSION" ]

    index_path=$(mktemp --suffix=.yaml)

    set -o xtrace

    curl --silent --show-error --fail "$url/index.yaml" --output "$index_path"
    version=$(yq --raw-output --arg chart "$chart" ".entries[\$chart][0].version" "$index_path")
    url=$(yq --raw-output --arg chart "$chart" ".entries[\$chart][0].urls[0]" "$index_path")
    sha256=$(nix-prefetch-url --unpack "$url")

    sed -i "s|version = \".*\";|version = \"$version\";|" "$filename"
    sed -i "s|url = \".*\";|url = \"$url\";|" "$filename"
    sed -i "s|sha256 = \".*\";|sha256 = \"$sha256\";|" "$filename"

    git add "$filename"
    git commit --message "$UPDATE_NIX_PNAME: $UPDATE_NIX_OLD_VERSION -> $version" || true
  '';

  meta = {
    platforms = lib.platforms.all;
  };
}
