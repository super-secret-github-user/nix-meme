{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell 
let 
  python_packages = p: with p; [
    slap-cli
  ]
{
  name = "kraken-wrapper";
  buildInputs = [
    (pkgs.python310.withPackages python_packages)
    (pkgs.poetry2nix.mkPoetryApplication {
      projectDir = ./.;
    })
  ];
}
