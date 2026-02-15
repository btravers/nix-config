{ inputs }:

[
  # Expose nixpkgs-unstable as pkgs.unstable.*
  (final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  })

  # Patch or override upstream packages
  (_final: _prev: { })

  # Custom local packages from ../pkgs
  (_final: _prev: { })
]
