pkgs:
let
  inherit (pkgs) system lib;

  callPackage = lib.callPackageWith pkgs;
  isAvailable = _: pkg: lib.meta.availableOn { inherit system; } pkg;

  packages = {
    age-plugin-tpm = callPackage ./age-plugin-tpm.nix { };
    hello = callPackage ./hello.nix { };
    swiftly = callPackage ./swiftly.nix { };
    swift6 = callPackage ./swift.nix { };
  };

in
lib.attrsets.filterAttrs isAvailable packages
