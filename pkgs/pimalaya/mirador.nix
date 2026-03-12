# See <https://github.com/pimalaya/mirador/blob/master/package.nix>
{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  apple-sdk,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  buildNoDefaultFeatures ? false,
  buildFeatures ? [ ],
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;

  pname = "mirador";
  version = "root-unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "mirador";
    rev = "979944376f851baf22e831eb2b05c2a856b73388";
    hash = "sha256-B+H49oTliiMMB/s/N9nim/Bsv/KOJOikm32Eh1vr3Fs=";
  };

  cargoHash = "sha256-JtLVk+Y58N66C4xUO2p3+MvO67AFdTPkkkXxYT3a1Hw=";

  inherit buildNoDefaultFeatures buildFeatures;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk;

  doCheck = false;
  auditable = false;

  # unit tests only
  cargoTestFlags = [ "--lib" ];

  postInstall = ''
    mkdir -p $out/share/{services,completions,man}
    cp assets/mirador@.service "$out"/share/services/
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out"/bin/mirador man "$out"/share/man
  ''
  + lib.optionalString installManPages ''
    installManPage "$out"/share/man/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out"/bin/mirador completion bash > "$out"/share/completions/mirador.bash
    "$out"/bin/mirador completion elvish > "$out"/share/completions/mirador.elvish
    "$out"/bin/mirador completion fish > "$out"/share/completions/mirador.fish
    "$out"/bin/mirador completion powershell > "$out"/share/completions/mirador.powershell
    "$out"/bin/mirador completion zsh > "$out"/share/completions/mirador.zsh
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion "$out"/share/completions/mirador.{bash,fish,zsh}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = rec {
    description = "CLI to watch mailbox changes";
    mainProgram = "mirador";
    homepage = "https://github.com/pimalaya/mirador";
    changelog = "${homepage}/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soywod ];
  };
}
