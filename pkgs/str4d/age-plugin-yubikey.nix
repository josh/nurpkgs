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
  version = "0.5.0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "age-plugin-yubikey";
    rev = "4f13e2fc279dd715a000708205463843776d445a";
    hash = "sha256-Z5nxxoSofrfRkbIJ3QsL79uapidQ1fJMkwADMYx08SE=";
  };

  cargoHash = "sha256-bGnowN+b4pKcUZ9jm97ZvyPmNxJfyzS9FUXdE+y8Hz8=";

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
