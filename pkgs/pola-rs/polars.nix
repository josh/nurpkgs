{ python3Packages }:
python3Packages.polars.overrideAttrs (
  _finalAttrs: prevAttrs: {
    passthru = builtins.removeAttrs prevAttrs.passthru [
      "updateScript"
      "tests"
    ];
  }
)
