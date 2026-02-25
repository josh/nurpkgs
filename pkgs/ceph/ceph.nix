{
  lib,
  stdenv,
  ceph,
}:
let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/724cf38d99ba81fbb4a347081db93e2e3a9bc2ae.tar.gz";
    sha256 = "02vmz2v8s3xf8r6r400b5kvy3v8vpqv1xxsd8ph38i69fz4hm41j";
  };
  pkgs' = import nixpkgs { inherit (stdenv.hostPlatform) system; };
in
if (lib.trivial.release == "26.05" && ceph.python.pkgs.sphinx.disabled) then pkgs'.ceph else ceph
