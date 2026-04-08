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
  version = "0.5.1-unstable-2026-04-08";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "age-plugin-yubikey";
    rev = "c3c0f474fca29e4ef8979ce7e0f4c06e9d5098e8";
    hash = "sha256-CZp+fCBGu7klx+NPss+WZ/LXnzONG0nz4ESOfvcvHOo=";
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
