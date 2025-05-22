{ pkgs, ...}:  pkgs.python3Packages.buildPythonPackage rec {
  pname = "pysimdjson";
  version = "6.0.2";
  pyproject = true;

  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-3b1v7NQqoBxch9PHm47eGIW2djM30hdFWHpTklcsH0U=";
  };
  build-system = with pkgs.python3Packages; [ setuptools cython ];
}
