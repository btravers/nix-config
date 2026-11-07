{
  description = "Nix-Darwin configuration";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    nix-darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      # nix-homebrew pins an older brew than the homebrew-core/cask taps
      # require; keep brew-src at least as new as the taps' DSL.
      inputs.brew-src.follows = "brew-src";
    };
    brew-src = {
      url = "github:Homebrew/brew/6.0.13";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-boring-notch = {
      url = "github:TheBoredTeam/homebrew-boring-notch";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      username = "btravers";
      system = "aarch64-darwin";
      helpers = import ./lib/helpers.nix { inherit inputs; };
    in
    {
      darwinConfigurations.${username} = helpers.mkDarwin {
        hostname = username;
        inherit username;
      };

      devShells.${system}.default =
        let
          pkgs = import inputs.nixpkgs { inherit system; };
        in
        pkgs.mkShellNoCC {
          packages = with pkgs; [
            (writeShellApplication {
              name = "apply-nix-darwin-configuration";
              runtimeInputs = [
                inputs.nix-darwin.packages.${system}.darwin-rebuild
              ];
              text = ''
                echo "> Applying nix-darwin configuration..."
                echo "> Running darwin-rebuild switch as root..."
                sudo darwin-rebuild switch --flake .
                echo "> darwin-rebuild switch was successful ✅"
                echo "> macOS config was successfully applied 🚀"
              '';
            })

            (writeShellApplication {
              name = "check-nix-darwin-configuration";
              runtimeInputs = [ ];
              text = ''
                echo "> Checking nix-darwin configuration for errors..."
                nix flake check
                echo "> Configuration check passed ✅"
              '';
            })

            (writeShellApplication {
              name = "diff-nix-darwin-configuration";
              runtimeInputs = [ nvd ];
              text = ''
                echo "> Building new configuration..."
                nix build .#darwinConfigurations.${username}.system --out-link /tmp/nix-darwin-new
                echo "> Comparing with current system..."
                nvd diff /run/current-system /tmp/nix-darwin-new
                rm /tmp/nix-darwin-new
              '';
            })

            self.formatter.${system}
          ];
        };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
