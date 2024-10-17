# Upstream to NixOS/nixpkgs
# - Needs to build from source rather than install binaries.
{
  system,
  lib,
  stdenvNoCC,
  fetchurl,
  runCommand,
  testers,
}:
let
  version = "0.34.0";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/tidbyt/pixlet/releases/download/v0.34.0/pixlet_0.34.0_darwin_arm64.tar.gz";
      sha256 = "0a13wj1pcwv2401zz719inc143n32ffblcax6974gvi32i462dh2";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/tidbyt/pixlet/releases/download/v0.34.0/pixlet_0.34.0_linux_arm64.tar.gz";
      sha256 = "1bkf4jjqmbwgfhay0yfliqays3pf97vgg53f92hdyphykhbqdhxq";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/tidbyt/pixlet/releases/download/v0.34.0/pixlet_0.34.0_linux_amd64.tar.gz";
      sha256 = "0h26qpf3ah7v45h4h4v4vycv4rppc8jd19cnwrs67p8331qx0csq";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixlet";
  inherit version;

  src = sources.${system};
  sourceRoot = ".";

  dontPatch = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp pixlet "$out/bin/pixlet"
  '';

  meta = {
    description = "Build apps for pixel-based displays";
    homepage = "https://github.com/tidbyt/pixlet";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainPackage = "pixlet";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pixlet version";
      version = "v${finalAttrs.version}";
    };

    help =
      runCommand "test-pixlet-help"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          pixlet --help
          touch $out
        '';
  };
})
