{ inputs }:

[
  # Expose nixpkgs-unstable as pkgs.unstable.*
  (final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  })

  # Disable direnv tests: fish test gets SIGKILL in macOS sandbox
  (_final: prev: {
    direnv = prev.direnv.overrideAttrs {
      doCheck = false;
    };
  })
]
