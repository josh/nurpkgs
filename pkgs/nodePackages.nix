{
  lib,
  writers,
  callPackage,
  writeShellScriptBin,
  nix,
  node2nix,
}:
let
  nodeEnv = callPackage ./nodePackages/node-env.nix { };

  packageNames = [
    "@anthropic-ai/claude-code"
    "@modelcontextprotocol/inspector"
    "@modelcontextprotocol/server-filesystem"
  ];
  packageNamesJSON = writers.writeJSON "node-packages.json" packageNames;

  updateScript = writeShellScriptBin "update-node-packages" ''
    set -o errexit
    set -o xtrace
    export PATH=${
      lib.strings.makeBinPath [
        nix
        node2nix
      ]
    }
    cd pkgs/nodePackages
    node2nix --input ${packageNamesJSON} --composition /dev/null
    nix fmt
  '';

  pkgs = callPackage ./nodePackages/node-packages.nix {
    inherit nodeEnv;
  };
in
pkgs // { inherit updateScript; }
