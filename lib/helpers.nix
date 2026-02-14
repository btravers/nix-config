{ inputs }:

{
  mkDarwin =
    {
      hostname,
      username ? "btravers",
      system ? "aarch64-darwin",
    }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs username hostname;
      };
      modules = [
        inputs.determinate.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs username hostname;
            };
            users.${username} = import ../home-manager;
          };
        }
        ../darwin
      ];
    };
}
