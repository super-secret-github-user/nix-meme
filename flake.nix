{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nr-utils = {
      url = "github:super-secret-github-user/python-nr.util";
      flake = false;
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

  outputs = { self, nixpkgs, poetry2nix, slap-cli, krakenw, nr-utils, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication defaultPoetryOverrides;
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
    	  databind2 = super.databind2.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  databind = super.databind.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  databind-json = super.databind-json.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  databind-json2 = super.databind-json2.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  databind-core = super.databind-core.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  databind-core2 = super.databind-core2.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools-scm ];
                  });
    	  typeapi = super.typeapi.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
                  });
    	  typing = super.typing.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry super.setuptools super.setuptools-scm super.poetry-core super.flit-core super.poetry-dynamic-versioning ];
                  });
    	  nr-date = super.nr-date.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry-core ];
                  });
    	  nr-stream = super.nr-stream.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry-core ];
                  });
    	  nr-util = super.nr-util.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry-core ];
                  });
    	  nr-util2 = super.nr-util2.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry-core ];
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
    	  kraken-common = super.kraken-common.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.poetry ];
                  });
    	  pathspec = super.pathspec.overridePythonAttrs
    	    ( old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.flit-core ];
                  });
        });
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          krakenw = (mkPoetryApplication {
            projectDir = krakenw.outPath;
            overrides = defaultPoetryOverrides.extend my_overrides;
          });
          slap = (mkPoetryApplication {
            projectDir = slap-cli.outPath;
            overrides = defaultPoetryOverrides.extend my_overrides;
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
