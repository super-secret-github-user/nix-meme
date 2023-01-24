{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    poetry2nix.url = "github:nix-community/poetry2nix";
    slap-cli = {
      url = "github:super-secret-github-user/slap";
      flake = false;
    };
    krakenw = {
      url = "github:/helsing-ai/kraken-wrapper";
      flake = false;
    };
  };

  outputs =

  { self, nixpkgs, poetry2nix, slap-cli, krakenw }:
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
