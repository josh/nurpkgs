{
  lib,
  python3,
  stdenvNoCC,
  git,
  nix,
}:
let
  python = python3.withPackages (ps: [
    ps.click
    ps.pyyaml
    ps.requests
  ]);
in
stdenvNoCC.mkDerivation {
  __structuredAttrs = true;

  name = "nixhelm-update";

  buildCommand = ''
    mkdir -p $out/bin
    (
      echo "#!${python.interpreter}"
      cat "${./nixhelm-update.py}"
    ) >$out/bin/nixhelm-update
    substituteInPlace $out/bin/nixhelm-update --replace-fail '@git@' '${git}/bin/git'
    substituteInPlace $out/bin/nixhelm-update --replace-fail '@nix-prefetch-url@' '${nix}/bin/nix-prefetch-url'
    substituteInPlace $out/bin/nixhelm-update --replace-fail '@nix@' '${nix}/bin/nix'
    chmod +x $out/bin/nixhelm-update
  '';

  meta = {
    mainProgram = "nixhelm-update";
    platforms = lib.platforms.all;
  };
}
