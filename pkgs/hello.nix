{
  lib,
  stdenv,
  writeText,
  cowsay,
}:
let
  wrapperScript = writeText "hello" ''
    #!${stdenv.shell}
    exec ${cowsay}/bin/cowsay "Hello, world!"
  '';
in
stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r ${wrapperScript} $out/bin/hello
    chmod +x $out/bin/hello
  '';

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      Hello is a program that prints "Hello, world!" when you run it.
    '';
    homepage = "https://example.com/";
    license = lib.licenses.mit;
    mainPackage = "hello";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
