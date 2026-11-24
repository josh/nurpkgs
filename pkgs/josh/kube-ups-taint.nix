{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "kube-ups-taint";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "josh";
    repo = "kube-ups-taint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TW54tRWwB1KFgVueN72RMvQxVxhJ7UHBxO/3e1Fz/hk=";
  };

  vendorHash = "sha256-4v+mwBz+AnrBeIYfNFmqJ7qUKSXv/uHfC3CREZm6KAs=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=stable" ]; };

  meta = {
    description = "Kubernetes controller that taints nodes when their UPS goes on battery";
    homepage = "https://github.com/josh/kube-ups-taint";
    license = lib.licenses.mit;
    mainProgram = "kube-ups-taint";
    platforms = lib.platforms.linux;
  };
})
