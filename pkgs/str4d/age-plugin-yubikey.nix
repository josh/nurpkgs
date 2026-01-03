{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  pcsclite,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "age-plugin-yubikey";
  version = "0.5.0-unstable-2025-12-25";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "age-plugin-yubikey";
    rev = "631f4426e1a5657b71420c4bb8e82676c6fb09c8";
    hash = "sha256-EqoriagkwQURyeYuNg/rWE5ctNAeGQkL7AonTlRoD9g=";
  };

  cargoHash = "sha256-qXZaHwKZ/7pFcIPxx8b6huAqab3Yqvfu9HKFnVc4Xfo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "YubiKey plugin for age";
    mainProgram = "age-plugin-yubikey";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
