{
  lib,
  system,
  stdenv,
  runCommand,
  testers,
  autoPatchelfHook,
  fetchurl,
  binutils,
  curl,
  glibc,
  icu,
  libgcc,
  libedit,
  libuuid,
  libxml2,
  ncurses,
  python3,
  sqlite,
  z3,
  swift6,
}:
let
  version = "6.0.1";
  sources = {
    "aarch64-linux" = fetchurl {
      url = "https://download.swift.org/swift-6.0.1-release/ubuntu2404-aarch64/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE-ubuntu24.04-aarch64.tar.gz";
      sha256 = "1sj9x13xs6ybmmd6aragw4ypr6b9gc1cxlgg3h22nvhgzqzmfj6m";
    };
    "x86_64-linux" = fetchurl {
      url = "https://download.swift.org/swift-6.0.1-release/ubuntu2404/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE-ubuntu24.04.tar.gz";
      sha256 = "12krrqiglpy611fsxbw1zpj057hyd6xjyrcq9cwcwcpiw65j5w6m";
    };
  };
in
stdenv.mkDerivation {
  pname = "swift";
  inherit version;
  src = sources.${system};
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    binutils
    curl
    glibc
    icu
    libedit
    libgcc.lib
    libuuid.lib
    libxml2
    ncurses
    python3
    sqlite
    z3.lib
  ];
  autoPatchelfIgnoreMissingDeps = [ "libedit.so.2" ];
  installPhase = ''
    cp -r usr/ $out
  '';

  meta = {
    description = "The Swift Programming Language";
    homepage = "https://github.com/swiftlang/swift";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainPackage = "swift";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru.tests = {
    version = testers.testVersion {
      package = swift6;
      command = "swift --version";
    };

    help =
      runCommand "test-swift-help"
        {
          nativeBuildInputs = [ swift6 ];
        }
        ''
          swift --help
          touch $out
        '';
  };
}
