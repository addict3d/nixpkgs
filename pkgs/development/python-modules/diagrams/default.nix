{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
#, poetry
, bash
, black
, jinja2
, round
, graphviz
, inkscape
, imagemagick
, pytest
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.17.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h5i9xb4fsmy81sznvqycxl712d9k695vznkpx2wm1ki7hvz86s8";
  };

  preConfigure = ''
    sed -i "s@#!/bin/bash@$!/${bash}/bin/bash@" autogen.sh
    ./autogen.sh
  '';

  # IDFK about python. but regular pip results in an empty python module
  #installPhase = ''
    #${poetry}/bin/poetry install
  #'';

  # the deps specified here below dont exactly match what is in pyproject.toml
  # I did not investigate whether/why the others are listed yet:
  #
  #[tool.poetry.dev-dependencies]
  #pylint = "^2.4"
  #rope = "^0.14.0"
  #isort = "^4.3"

  checkInputs = [ pytest ];
  nativeBuildInputs = [ black jinja2 inkscape imagemagick round ];
  propagatedBuildInputs = [ graphviz ];
  # I did not test the complete functionality. inkscape/imagemagick might be runtime deps for some output types?

  # note: check outscale package.
  # it was broken in my previous attempt from pypi,
  # the file `outscale/__init__.py` was missing

  checkPhase = ''
    python -m unittest -v tests/*.py
  '';

  meta = with lib; {
    description = "Diagram as Code";
    homepage    = "https://diagrams.mingrammer.com/";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
