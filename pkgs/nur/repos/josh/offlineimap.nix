{
  offlineimap',
  fetchFromGitHub,
  fetchpatch,
}:
offlineimap'.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "8.0.0.24";

    src = fetchFromGitHub {
      owner = "OfflineIMAP";
      repo = "offlineimap3";
      rev = "1a1f02b440015031c09996313eb30ad911162cf8";
      hash = "sha256-7ddSOq0j4EXuYIxIWMfYzCr1bhQx6SsLEwOyKrYbuEA=";
    };

    patches = [
      (fetchpatch {
        name = "python312-comaptibility.patch";
        url = "https://github.com/OfflineIMAP/offlineimap3/commit/a1951559299b297492b8454850fcfe6eb9822a38.patch";
        hash = "sha256-CBGMHi+ZzOBJt3TxBf6elrTRMIQ+8wr3JgptL2etkoA=";
      })
    ];
  }
)
