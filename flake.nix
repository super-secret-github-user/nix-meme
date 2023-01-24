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
	my_overrides = ( self: super: {
	# needed for slap
	  types-pygments = super.types-pygments.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
              }); 
	  types-beautifulsoup4 = super.types-beautifulsoup4.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
              }); 
	  databind = super.databind.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  databind-json = super.databind-json.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  databind-core = super.databind-core.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  typeapi = super.typeapi.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  nr-util = super.nr-util.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  nr-python-environment = super.nr-python-environment.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  pygments = super.pygments.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	# needed for kw
	  nr-io-lexer = super.nr-io-lexer.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  types-termcolor = super.types-termcolor.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
              }); 
	  builddsl = super.builddsl.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
	  iniconfig = super.iniconfig.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.hatchling super.hatch-vcs ];
              }); 
	  kraken-common = super.kraken-common.overridePythonAttrs
	    ( old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
              }); 
        });
      in
      {
        devShells.default =  pkgs.mkShell {
          name = "kraken-wrapper";
          buildInputs = [
            (pkgs.poetry2nix.mkPoetryApplication {
              projectDir = krakenw.outPath;
	      overrides = pkgs.poetry2nix.defaultPoetryOverrides.extend my_overrides;
            })

            (pkgs.poetry2nix.mkPoetryApplication {
              projectDir = slap-cli.outPath;
	      overrides = pkgs.poetry2nix.defaultPoetryOverrides.extend my_overrides;
            })
          ];
        };
      }
    );
}
