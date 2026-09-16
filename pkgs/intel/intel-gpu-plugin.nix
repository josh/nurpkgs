{
  lib,
  buildGoModule,
  fetchFromGitHub,

  nix-update-script,
  runCommand,
}:
buildGoModule (finalAttrs: {
  pname = "intel-gpu-plugin";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-device-plugins-for-kubernetes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-93suKBJ3XZE0XcVgu+R9CunRtkMwp06cNBdE/V0/Tq4=";
  };

  vendorHash = "sha256-2bvBpMJH/XUM3wJU8fbkGCSatcry6zzDpRN4l/Q3rUo=";

  subPackages = [ "cmd/gpu_plugin" ];

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    help =
      runCommand "test-intel-gpu-plugin-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          gpu_plugin -h 2>output.txt || true
          grep --quiet -- "-shared-dev-num" output.txt
          grep --quiet -- "-allocation-policy" output.txt
          touch $out
        '';
  };

  meta = {
    description = "Kubernetes device plugin advertising Intel GPUs as gpu.intel.com/i915 resources";
    homepage = "https://github.com/intel/intel-device-plugins-for-kubernetes";
    license = lib.licenses.asl20;
    mainProgram = "gpu_plugin";
    platforms = lib.platforms.linux;
  };
})
