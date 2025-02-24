final: _prev:
let
  inherit (final) lib;
  pkgs = lib.filesystem.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./pkgs;
  };
in
{
  nur.repos.josh = pkgs;
}
