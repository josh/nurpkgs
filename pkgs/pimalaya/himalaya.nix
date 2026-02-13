# See <https://github.com/pimalaya/himalaya/blob/master/package.nix>
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
  notmuch,
  gpgme,
  buildNoDefaultFeatures ? false,
  buildFeatures ? [ ],
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;

  pname = "himalaya";
  version = "1.1.0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "himalaya";
    rev = "c64710aad4cc4ed2949fdb7cdc8f75445b72f28a";
    hash = "sha256-yr0PF/yxQxEZYhyXGoguP8hsT/tTJR8DwMv7nCG5xe8=";
  };

  cargoHash = "sha256-x7TbS74rbJ2KPFie8zi9aFKJhr/72aSF5BfXxFlU9XQ=";

  inherit buildNoDefaultFeatures buildFeatures;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    lib.optional stdenv.hostPlatform.isDarwin apple-sdk
    ++ lib.optional (builtins.elem "notmuch" buildFeatures) notmuch
    ++ lib.optional (builtins.elem "pgp-gpg" buildFeatures) gpgme;

  doCheck = false;
  auditable = false;

  # unit tests only
  cargoTestFlags = [ "--lib" ];

  postInstall = ''
    mkdir -p $out/share/{applications,completions,man}
    cp assets/himalaya.desktop "$out"/share/applications/
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out"/bin/himalaya man "$out"/share/man
  ''
  + lib.optionalString installManPages ''
    installManPage "$out"/share/man/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    "$out"/bin/himalaya completion bash > "$out"/share/completions/himalaya.bash
    "$out"/bin/himalaya completion elvish > "$out"/share/completions/himalaya.elvish
    "$out"/bin/himalaya completion fish > "$out"/share/completions/himalaya.fish
    "$out"/bin/himalaya completion powershell > "$out"/share/completions/himalaya.powershell
    "$out"/bin/himalaya completion zsh > "$out"/share/completions/himalaya.zsh
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion "$out"/share/completions/himalaya.{bash,fish,zsh}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = rec {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "${homepage}/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soywod
      toastal
      yanganto
    ];
  };
}
