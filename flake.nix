{
  inputs = { flake-utils.url = "github:numtide/flake-utils"; };
  outputs = { self, flake-utils, nixpkgs, ... }:
    # use flake utils to make this flake compatible with all OS/architectures
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree rec {
          default = ctlssa;
          # package configuration for CTLSSA package
          ctlssa = pkgs.python3Packages.buildPythonPackage {
            pname = "ctlssa";
            version = "0.0.1";
            pyproject = true;

            src = self;

            dontCheckRuntimeDeps = true;

            dependencies = (with pkgs.python3Packages; [ colorlog tldextract django python-xz psycopg ])
              ++ [ pkgs.uwsgi certstream pysimdjson ];

            # required for pyproject
            build-system = with pkgs.python3Packages; [ setuptools setuptools-scm ];

          };
          # package configurations for packages that are not in Nixpkgs
          certstream = pkgs.python3Packages.buildPythonPackage rec {
            pname = "certstream";
            version = "1.12";
            pyproject = true;

            src = pkgs.python3Packages.fetchPypi {
              inherit pname version;
              hash = "sha256-5pLWXqlEel22zRRsWWmvZDTt2HFj/gsQCWK7XX0iPds=";
            };

            dependencies = with pkgs.python3Packages; [ websocket-client termcolor ];
            build-system = with pkgs.python3Packages; [ setuptools ];
          };
          pysimdjson = pkgs.python3Packages.buildPythonPackage rec {
            pname = "pysimdjson";
            version = "6.0.2";
            pyproject = true;

            src = pkgs.python3Packages.fetchPypi {
              inherit pname version;
              hash = "sha256-3b1v7NQqoBxch9PHm47eGIW2djM30hdFWHpTklcsH0U=";
            };
            build-system = with pkgs.python3Packages; [ setuptools ];
          };
        };
        # create a shell configuration for running/developing CTLSSA using `nix develop` or Direnv
        devShells.default = pkgs.mkShell {
          DJANGO_SETTINGS_MODULE = "ctlssa.app.settings";
          UWSGI_MODULE = "ctlssa.app.wsgi";
          UWSGI_HTTP_SOCKET = ":8001";
          UWSGI_MASTER = "1";
          UWSGI_UID = "nobody";
          DJANGO_PORT = "8001";

          buildInputs = [ packages.ctlssa ];
        };
        # add module for installing CTLSSA in NixOS
        nixosModules.default = ({ pkgs, ... }: {
          imports = [ ./module.nix ];
          nixpkgs.overlays = [ (_self: _super: { ctlssa = self.packages.${pkgs.system}.ctlssa; }) ];
        });
      });
}
