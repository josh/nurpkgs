{
  system,
  lib,
  writeShellApplication,
  nix-update,
  git,
  nur,
}:
let
  commands = lib.attrsets.mapAttrsToList (
    name: pkg:
    if !(builtins.hasAttr "updateScriptVersion" pkg) then
      '': skip ${name} does not have updateScriptVersion''
    else if !pkg.meta.available then
      '': skip ${name} unavailable on ${system}''
    else
      ''nix-update --flake --commit ${name} --version=${pkg.passthru.updateScriptVersion}''
  ) nur.repos.josh;
  text = lib.concatStringsSep "\n" commands;
in
writeShellApplication {
  name = "update-script";
  runtimeEnv = {
    PATH = lib.strings.makeBinPath [
      git
      nix-update
    ];
  };
  bashOptions = [ "xtrace" ];
  inherit text;
}
