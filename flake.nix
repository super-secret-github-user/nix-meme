{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication defaultPoetryOverrides;
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          krakenw = (mkPoetryApplication {
            projectDir = krakenw.outPath;
          });
          slap = (mkPoetryApplication {
            projectDir = slap-cli.outPath;
          });
        };
        
        devShells.default = pkgs.mkShell {
          name = "Helsing tooling";

          buildInputs = [
	        packages.krakenw
	        packages.slap
          ];
        };
      }
    );
}
