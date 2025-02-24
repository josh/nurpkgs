{
  pkgs ? import <nixpkgs> { },
}:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // { nur.repos.josh = pkgs'; });
  pkgs' = pkgs.lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./pkgs;
  };
in
pkgs'
