# FLAKE_URI="$PWD" nix eval --raw --impure --file ./internal/update-script-matrix.nix
let
  flake = builtins.getFlake (builtins.getEnv "FLAKE_URI");

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  attrNames = builtins.attrNames (
    builtins.foldl' (acc: system: acc // flake.packages.${system}) { } systems
  );

  hasUpdateScript =
    system: name:
    let
      pkg = flake.packages.${system}.${name} or null;
    in
    pkg != null
    && (pkg.updateScript or null) != null
    && builtins.elem system (pkg.meta.platforms or [ ]);

  preferredSystem =
    name:
    let
      candidates = builtins.filter (system: hasUpdateScript system name) systems;
    in
    if candidates == [ ] then null else builtins.head candidates;

  include = builtins.filter (entry: entry.system != null) (
    builtins.map (attr: {
      inherit attr;
      system = preferredSystem attr;
    }) attrNames
  );
in
"matrix=${builtins.toJSON { inherit include; }}"
