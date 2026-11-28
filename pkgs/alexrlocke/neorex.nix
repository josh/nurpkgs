{
  lib,
  stdenv,
  fetchFromGitHub,
  # nixos-26.05 predates Zig 0.17
  zig_0_17 ? null,
  nix-update-script,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neorex";
  version = "0.2.0-unstable-2026-11-28";

  src = fetchFromGitHub {
    owner = "alexrlocke";
    repo = "neorex";
    rev = "6676c8a18edf35d9102bcbc60694006f585f52f2";
    hash = "sha256-kTzN7hhp9fFAzcBJhyCVoVUxvNygSZjAVPRoNNjC6Jk=";
  };

  nativeBuildInputs = [
    zig_0_17.hook
  ];

  # Upstream tests need git, ripgrep, a writable HOME and a git checkout
  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests = {
    help = runCommand "test-neorex-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      neorex help
      touch $out
    '';
  };

  meta = {
    description = "Rex-native frontend for Neovim";
    homepage = "https://github.com/alexrlocke/neorex";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "neorex";
    broken = zig_0_17 == null;
  };
})
