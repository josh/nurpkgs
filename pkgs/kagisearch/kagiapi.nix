{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "kagiapi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kagisearch";
    repo = "kagiapi";
    rev = "dd05bb218dcf76cbc72d7ae6c58f5fc56dd9fabc";
    hash = "sha256-2MaYftb+qQo/tdDuHjFzwTQaaVVIcMWL3i4qmeYBAJ4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version="0.1.0"' 'version="0.2.1"'
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.requests
    python3Packages.typing-extensions
  ];

  pythonImportsCheck = [ "kagiapi" ];

  meta = {
    description = "A Python package for Kagi Search API";
    homepage = "https://github.com/kagisearch/kagiapi";
    license = lib.licenses.mit;
  };
}
