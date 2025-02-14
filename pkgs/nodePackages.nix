{
  lib,
  callPackage,
  writeShellScript,
  node2nix,
}:
let
  nodeEnv = callPackage ./nodePackages/node-env.nix { };

  updateScript = writeShellScript "update-node-packages" ''
    set -o errexit
    set -o xtrace
    export PATH=${lib.strings.makeBinPath [ node2nix ]}
    cd pkgs/nodePackages
    node2nix --input ./node-packages.json --composition /dev/null
  '';

  pkgs = callPackage ./nodePackages/node-packages.nix {
    inherit nodeEnv;
  };
in
pkgs // { inherit updateScript; }
