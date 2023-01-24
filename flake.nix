{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    slap-cli = {
      url = "github:super-secret-github-user/slap";
      flake = false;
    };
    krakenw = {
      url = "github:/helsing-ai/kraken-wrapper";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, poetry2nix, slap-cli, krakenw, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default =  pkgs.mkShell {
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
      }
    );
}
