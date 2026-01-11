pkgs:
args@{
  url,
  chart,
  version,
  sha256,
}:
let
  inherit (pkgs) lib callPackage stdenvNoCC;
  nixhelm-update = callPackage ./nixhelm-update.nix { };
in
stdenvNoCC.mkDerivation {
  __structuredAttrs = true;

  pname = "${chart}-chart";
  inherit version;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  nativeBuildInputs = with pkgs; [
    kubernetes-helm
  ];

  helmChart = chart;
  helmPullArgs =
    if (lib.strings.hasPrefix "oci://" url) then
      [
        url
        "--version"
        version
      ]
    else
      [
        chart
        "--repo"
        url
        "--version"
        version
      ];

  buildCommand = ''
    export HELM_CACHE_HOME=$TMPDIR/cache
    helm pull "''${helmPullArgs[@]}" --destination ./out --untar
    cp -R ./out/"$helmChart" $out
  '';

  passthru.updateScript =
    if (lib.strings.hasPrefix "oci://" url) then
      [
        "${lib.getExe nixhelm-update}"
        "--url"
        url
      ]
    else
      [
        "${lib.getExe nixhelm-update}"
        "--url"
        chart
        "--repo"
        url
      ];

  meta = {
    description = "Fetch Helm chart";
    platforms = lib.platforms.all;
  };

  pos = builtins.unsafeGetAttrPos "url" args;
}
