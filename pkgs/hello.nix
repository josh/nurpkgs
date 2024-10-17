{
  lib,
  stdenv,
  writeText,
  cowsay,
  runCommand,
}:
let
  wrapperScript = writeText "hello" ''
    #!${stdenv.shell}
    exec ${cowsay}/bin/cowsay "Hello, world!"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "0.1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r ${wrapperScript} $out/bin/hello
    chmod +x $out/bin/hello
  '';

  # doInstallCheck = true;
  # nativeInstallCheckInputs = [
  #   versionCheckHook
  # ];

  # See https://nixos.org/manual/nixpkgs/unstable/
  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      Hello is a program that prints "Hello, world!" when you run it.
    '';
    homepage = "https://example.com/";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainPackage = "hello";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru.tests = {
    # version = testers.testVersion { package = hello; };
    run =
      runCommand "hello-test-run"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          hello
          touch $out
        '';
  };
})
