{ inputs }:

[
  # Disable direnv tests: fish test gets SIGKILL in macOS sandbox
  (_final: prev: {
    direnv = prev.direnv.overrideAttrs {
      doCheck = false;
    };
  })
]
