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
      eachSystem = lib.genAttrs systems;
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      overlays.default =
        final: prev:
        let
          inherit (final) lib;
          prev' = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair "${name}'") prev;
          callPackage = lib.callPackageWith (final // prev');
          pkgs = lib.filesystem.packagesFromDirectoryRecursive {
            inherit callPackage;
            directory = ./pkgs;
          };
        in
        {
          nur.repos.josh = pkgs;
        };

      packages = eachSystem (
        system:
        let
          isAvailable = _: pkg: pkg.meta.available;
          pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
        in
        lib.attrsets.filterAttrs isAvailable pkgs.nur.repos.josh
      );

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
      checks = eachSystem (
        system:
        let
          addAttrsetPrefix = prefix: lib.attrsets.concatMapAttrs (n: v: { "${prefix}${n}" = v; });
          localTests = lib.attrsets.concatMapAttrs (
            pkgName: pkg:
            if (builtins.hasAttr "tests" pkg) then
              ({ "${pkgName}-build" = pkg; } // (addAttrsetPrefix "${pkgName}-tests-" pkg.tests))
            else
              { "${pkgName}-build" = pkg; }
          ) self.packages.${system};
        in
        {
          formatting = treefmtEval.${system}.config.build.check self;
        }
        // localTests
      );
    };
}
