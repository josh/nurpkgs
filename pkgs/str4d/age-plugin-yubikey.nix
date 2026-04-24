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
  version = "0.5.1-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "age-plugin-yubikey";
    rev = "cafbc75fbd309e6f7ab62749052f98a91a89764e";
    hash = "sha256-p1uMp6JK0jdm77DBHMT8XoFMwNYIkE8VO2Gq5mBdprA=";
  };

  cargoHash = "sha256-TV4Bxzlb9xyM/OdXrlYFbUyqgHkdqT7heSGZHW+YUFw=";

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
