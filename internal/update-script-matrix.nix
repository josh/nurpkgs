# FLAKE_URI="$PWD" nix eval --raw --file ./internal/update-script-matrix.nix
let
  system = builtins.currentSystem;
  flake = builtins.getFlake (builtins.getEnv "FLAKE_URI");
  pkgs = flake.packages.${system};

  runnerOS =
    pkg:
    let
      platforms = pkg.meta.platforms or [ ];
    in
    if builtins.elem "x86_64-linux" platforms then
      "ubuntu-24.04"
    else if builtins.elem "aarch64-linux" platforms then
      "ubuntu-24.04-arm"
    else if builtins.elem "aarch64-darwin" platforms then
      "macos-15"
    else
      null;

  commands = builtins.filter (x: x != null) (
    builtins.map (
      name:
      let
        pkg = pkgs.${name};
        os = runnerOS pkg;
      in
      if (builtins.hasAttr "updateScript" pkg) && (os != null) then
        {
          "attr" = name;
          "os" = os;
        }
      else
        null
    ) (builtins.attrNames pkgs)
  );

  matrix = {
    include = commands;
  };
in
"matrix=${builtins.toJSON matrix}"
