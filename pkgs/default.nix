pkgs:
let
  inherit (pkgs) system lib;

  callPackage = lib.callPackageWith (pkgs // packages);
  isAvailable = _: pkg: lib.meta.availableOn { inherit system; } pkg;

  packages = {
    age-plugin-tpm = callPackage ./age-plugin-tpm.nix {
      # TODO: Is there a better way to handle overriding nixpkgs?
      age-plugin-tpm' = pkgs.age-plugin-tpm;
    };
    hello = callPackage ./hello.nix { };
    swiftly = callPackage ./swiftly.nix { };
    swift6 = callPackage ./swift.nix { };
  };

in
lib.attrsets.filterAttrs isAvailable packages
