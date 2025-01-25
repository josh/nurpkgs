{ stdenv, swtpm }:

if stdenv.hostPlatform.isDarwin then
  swtpm.overrideAttrs (
    _finalAttrs: prevAttrs: {
      doCheck = false;
      postPatch =
        prevAttrs.postPatch
        + ''
          substituteInPlace tests/Makefile.am \
            --replace 'install-data-hook:' 'do-not-execute:'
        '';
      passthru.tests = { };
    }
  )
else
  swtpm.overrideAttrs {
    passthru.tests = { };
  }
