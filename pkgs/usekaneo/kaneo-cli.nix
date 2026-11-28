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
  version = "0.2.0";

  outputs = [
    "out"
    "skill"
  ];

  src = fetchurl {
    url = "https://registry.npmjs.org/@kaneo/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-dI9ISvMKm0PE9TY9sDvCATmxv6NrSWM7dTHllqs8DBQ=";
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

    install -Dm644 ${finalAttrs.passthru.skillSrc} $skill/SKILL.md

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    export HOME=$TMPDIR
    installShellCompletion --cmd kaneo \
      --bash <($out/bin/kaneo --completions bash) \
      --fish <($out/bin/kaneo --completions fish) \
      --zsh <($out/bin/kaneo --completions zsh)
  '';

  passthru.skillSrc = fetchurl {
    url = "https://raw.githubusercontent.com/usekaneo/kaneo/cli-v${finalAttrs.version}/skills/kaneo-cli/SKILL.md";
    hash = "sha256-csU9NCpxibcVtAN+Z7I/aQ4aPACNDKhG4bxUs3MPOxs=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=stable"
      "--custom-dep"
      "skillSrc"
    ];
  };

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
    skill = runCommand "test-kaneo-cli-skill" { } ''
      head -n1 ${finalAttrs.finalPackage.skill}/SKILL.md | grep -qx -- ---
      sed -n '1,/^---$/{1d;p}' ${finalAttrs.finalPackage.skill}/SKILL.md | grep -qx 'name: kaneo-cli'
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
