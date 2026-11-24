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
  version = "0.2.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "alexrlocke";
    repo = "neorex";
    rev = "7672427e0ddaaae4e6951e4b8ac33d5bc7359899";
    hash = "sha256-hP4W7pnnr+Mg928d+LjSkDHQ14yxezo9Wbi3ChWcOtg=";
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
