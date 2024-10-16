pkgs:
let
  inherit (pkgs) system lib;

  callPackage = lib.callPackageWith (pkgs // packages);
  isAvailable = _: pkg: lib.meta.availableOn { inherit system; } pkg;

  packages = {
    hello = callPackage ./hello.nix { };
  };
in
lib.attrsets.filterAttrs isAvailable packages
