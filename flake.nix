{
  description = "@josh's Nix User Repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.hello = nixpkgs.legacyPackages.aarch64-darwin.hello;
    packages.aarch64-linux.hello = nixpkgs.legacyPackages.aarch64-linux.hello;
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
  };
}
