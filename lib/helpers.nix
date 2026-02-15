{ inputs }:

let
  overlays = import ../overlays { inherit inputs; };
in
{
  mkDarwin =
    {
      hostname,
      username ? "btravers",
      system ? "aarch64-darwin",
      isWorkstation ? true,
      isLaptop ? true,
    }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          username
          hostname
          isWorkstation
          isLaptop
          ;
      };
      modules = [
        { nixpkgs.overlays = overlays; }
        inputs.determinate.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.mac-app-util.darwinModules.default
        inputs.sops-nix.darwinModules.sops
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit
                inputs
                username
                hostname
                isWorkstation
                isLaptop
                ;
            };
            sharedModules = [
              inputs.mac-app-util.homeManagerModules.default
              inputs.nix-index-database.homeModules.nix-index
              inputs.sops-nix.homeManagerModules.sops
              inputs.catppuccin.homeModules.catppuccin
            ];
            users.${username} = import ../home-manager;
          };
        }
        ../darwin
      ];
    };
}
