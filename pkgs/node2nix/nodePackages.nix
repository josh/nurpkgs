{
  path,
  lib,
  callPackage,
  symlinkJoin,
  writeShellApplication,
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

  updateScript = writeShellApplication {
    name = "update-node-packages";
    runtimeEnv = {
      PATH = lib.strings.makeBinPath [
        nix
        node2nix
        nixfmt-rfc-style
      ];
    };
    text = ''
      set -o xtrace
      pushd pkgs/node2nix/generated
      node2nix --input ${packageNamesFile} --composition /dev/null --node-env /dev/null
      nixfmt node-packages.nix
      popd
      nix fmt
      git add pkgs/node2nix/generated
      git commit --message "Update node2nix packages"
    '';
  };

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
