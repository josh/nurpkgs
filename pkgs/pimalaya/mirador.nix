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
  version = "0-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "mirador";
    rev = "942e293af6fc9c3f7997013bf03dd0a35eac86f5";
    hash = "sha256-sHjsZVq+N9F3O4YNKE5xfoXRVfk2srkAP1O2UkjT+jk=";
  };

  cargoHash = "sha256-PlgqC14ARHvAkAGSLmJ8y2JD4K2zZb433d+owGQdMuY=";

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
