{
  description = "@josh's Nix User Repository";

  nixConfig = {
    extra-substituters = [
      "https://josh.cachix.org"
    ];
    extra-trusted-public-keys = [
      "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      inherit (nixpkgs) lib;
      eachSystem = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      packages = eachSystem (
        pkgs:
        let
          inherit (pkgs) system;
          isAvailable = _: lib.meta.availableOn { inherit system; };
          packages = lib.filesystem.packagesFromDirectoryRecursive {
            callPackage = lib.callPackageWith (
              pkgs
              // {
                final = packages;
                prev = pkgs;
              }
            );
            directory = ./pkgs;
          };
        in
        lib.attrsets.filterAttrs isAvailable packages
      );
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
        tests = pkgs.runCommand "nurpkgs-tests" {
          nativeBuildInputs = lib.concatMap (
            pkg:
            if (builtins.hasAttr "tests" pkg.passthru) then (builtins.attrValues pkg.passthru.tests) else [ ]
          ) (lib.attrValues self.packages.${pkgs.system});
        } "touch $out";
      });
    };
}
