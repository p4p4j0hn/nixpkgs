{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pkg-config
, setuptools
, igraph
, texttable
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "igraph";
  version = "0.11.4";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    rev = "refs/tags/${version}";
    hash = "sha256-sR9OqsBxP2DvcYz1dhIP29rrQ56CRKW02oNAXUNttio=";
  };

  postPatch = ''
    rm -r vendor
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    igraph
  ];

  propagatedBuildInputs = [
    texttable
  ];

  # NB: We want to use our igraph, not vendored igraph, but even with
  # pkg-config on the PATH, their custom setup.py still needs to be explicitly
  # told to do it. ~ C.
  env.IGRAPH_USE_PKG_CONFIG = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "igraph" ];

  meta = with lib; {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    changelog = "https://github.com/igraph/python-igraph/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MostAwesomeDude dotlambda ];
  };
}
