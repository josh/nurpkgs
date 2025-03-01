{
  path,
  lib,
  callPackage,
  symlinkJoin,
  writeShellScript,
  nix,
  node2nix,
  nixfmt-rfc-style,
}:
let
  packageNames = [
    "@anthropic-ai/claude-code"
    "@modelcontextprotocol/inspector"
    "@modelcontextprotocol/server-filesystem"
  ];
  packageNamesFile = builtins.toFile "node-packages.json" (builtins.toJSON packageNames);

  runtimePath = lib.strings.makeBinPath [
    nix
    node2nix
    nixfmt-rfc-style
  ];

  updateScript = writeShellScript "update-node-packages" ''
    set -o errexit
    set -o nounset
    set -o pipefail
    set -o xtrace
    export PATH=${runtimePath}

    pushd pkgs/node2nix/generated
    node2nix --input ${packageNamesFile} --composition /dev/null --node-env /dev/null
    nixfmt node-packages.nix
    git add node-packages.nix
    popd

    git commit --message "Update node2nix packages"
  '';

  nodeEnv = callPackage "${path}/pkgs/development/node-packages/node-env.nix" { };

  nodePackages = callPackage ./generated/node-packages.nix {
    inherit nodeEnv;
  };

  nodePackages' = builtins.removeAttrs nodePackages [
    "override"
    "overrideDerivation"
  ];
in
symlinkJoin {
  name = "node-packages";
  paths = builtins.attrValues nodePackages';
  passthru = nodePackages' // {
    inherit updateScript;
  };
}
