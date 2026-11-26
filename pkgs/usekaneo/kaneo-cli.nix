{
  lib,
  stdenvNoCC,
  fetchurl,

  installShellFiles,
  makeBinaryWrapper,
  nodejs,

  nix-update-script,
  runCommand,
  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kaneo-cli";
  version = "0.1.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@kaneo/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-dmDVPWp85vh1ugylwUndHg/R+nMMH55RGqRgsIKFiyY=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/kaneo-cli
    cp -r dist package.json $out/lib/kaneo-cli/
    makeWrapper ${lib.getExe nodejs} $out/bin/kaneo \
      --add-flags $out/lib/kaneo-cli/dist/kaneo.mjs

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    export HOME=$TMPDIR
    installShellCompletion --cmd kaneo \
      --bash <($out/bin/kaneo --completions bash) \
      --fish <($out/bin/kaneo --completions fish) \
      --zsh <($out/bin/kaneo --completions zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR kaneo --version";
    };
    help = runCommand "test-kaneo-cli-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      export HOME="$TMPDIR"
      kaneo --help
      kaneo task --help
      test -s ${finalAttrs.finalPackage}/share/bash-completion/completions/kaneo.bash
      test -s ${finalAttrs.finalPackage}/share/fish/vendor_completions.d/kaneo.fish
      test -s ${finalAttrs.finalPackage}/share/zsh/site-functions/_kaneo
      touch $out
    '';
  };

  meta = {
    description = "Official command-line client for Kaneo";
    homepage = "https://kaneo.app/docs/cli";
    changelog = "https://github.com/usekaneo/kaneo/releases/tag/cli-v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "kaneo";
    inherit (nodejs.meta) platforms;
  };
})
