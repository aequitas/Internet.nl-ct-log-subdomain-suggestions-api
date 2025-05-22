{ self, pkgs, ... }: pkgs.python3Packages.buildPythonPackage rec {
  pname = "ctlssa";
  version = "0.0.1";
  pyproject = true;

  src = self;

  dontCheckRuntimeDeps = true;

  dependencies = (with pkgs.python3Packages; [ colorlog tldextract django python-xz psycopg ]) ++ [
    pkgs.uwsgi
    (pkgs.callPackage ./certstream.nix { inherit pkgs; })
    # pkgs.callPackage ./pysimdjson.nix { inherit pkgs; }
  ];

  propagatedBuildInputs = dependencies;
  # propagateBuildInputs???? of iets anders om de dependencies in de pythonpath van uwsgi door te laten komen

  # required for pyproject
  build-system = with pkgs.python3Packages; [ setuptools setuptools-scm ];
}
