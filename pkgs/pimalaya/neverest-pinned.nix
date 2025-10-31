{ stdenv }:
let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/f937f8ecd1c70efd7e9f90ba13dfb400cf559de4.tar.gz";
    sha256 = "sha256-4/Jd+LkQ2ssw8luQVkqVs9spDBVE6h/u/hC/tzngsPo=";
  };
  pkgs = import nixpkgs { inherit (stdenv.hostPlatform) system; };
in
(pkgs.callPackage ./neverest.nix { }).overrideAttrs (previousAttrs: {
  meta = previousAttrs.meta // {
    broken = false;
  };
})
