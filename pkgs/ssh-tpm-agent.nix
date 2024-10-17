{
  fetchFromGitHub,
  runCommand,
  ssh-tpm-agent,
}:
ssh-tpm-agent.overrideAttrs (
  _finalAttrs: _previousAttrs: {
    version = "0.6.0";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "ssh-tpm-agent";
      rev = "v0.6.0";
      hash = "sha256-gO9qVAVCvaiLrC/GiTJ0NghiXVRXXRBlvOIVSAOftR8=";
    };
    vendorHash = "sha256-Upq8u5Ip0HQW5FGyqhVUT6rINXz2BpCE7lbtk9fPaWs=";

    passthru.tests = {
      help =
        runCommand "test-ssh-tpm-agent-help"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            ssh-tpm-agent --help
            touch $out
          '';
    };
  }
)
