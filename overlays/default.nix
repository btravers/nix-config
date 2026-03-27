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
  # Fix direnv build: remove -linkmode=external incompatible with CGO_ENABLED=0
  # (upstream fix: https://github.com/NixOS/nixpkgs/pull/486452)
  (_final: prev: {
    direnv = prev.direnv.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace GNUmakefile --replace-fail " -linkmode=external" ""
        '';
    });
  })

  # Custom local packages from ../pkgs
  (_final: _prev: { })
]
