{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    slap-cli.url = "github:NiklasRosenstein/slap";
    krakenw.url = "github:/kraken-build/kraken-wrapper";
  };

  outputs =

  { self, nixpkgs, slap-cli, krakenw }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      shell =
      pkgs.mkShell
      {
        name = "kraken-wrapper";
        buildInputs = [
          (pkgs.poetry2nix.mkPoetryApplication {
            projectDir = krakenw.outPath;
          })
          (pkgs.poetry2nix.mkPoetryApplication {
            projectDir = slap-cli.outPath;
          })
        ];
      };
  in
  {
    devShells.x86_64-linux.default = shell;
  };
}
