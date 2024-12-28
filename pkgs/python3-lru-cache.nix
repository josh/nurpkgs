{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage rec {
  pname = "lru-cache";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josh";
    repo = "lru-cache-python";
    rev = "v${version}";
    hash = "sha256-CYBSoBLNa29NPHwgmaYaegMzsJF0Jndik/rYwVTKdVk=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  passthru.updateScriptVersion = "stable";

  meta = {
    homepage = "https://github.com/josh/lru-cache-python";
    description = "Persisted LRU cache Python module";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}