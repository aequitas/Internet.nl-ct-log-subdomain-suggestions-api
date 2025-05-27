{ self, pkgs, ...} : pkgs.python3Packages.buildPythonPackage rec {
    pname = "ctlssa";
    version = "0.0.1";
    pyproject = true;

    src = self;

    # dontCheckRuntimeDeps = true;

    dependencies = (with pkgs.python3Packages; [ colorlog tldextract django python-xz psycopg ])
      ++ [ pkgs.uwsgi self.packages.certstream
        # pysimdjson
      ];

    propagatedBuildInputs = dependencies;

    # required for pyproject
    build-system = with pkgs.python3Packages; [ setuptools setuptools-scm ];
  }
