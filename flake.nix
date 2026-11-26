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
      inputs.brew-src.follows = "brew-src";
    };
    # brew must be at least as new as the taps' DSL; nix-homebrew's bundled brew
    # lags behind. Bump this tag (latest Homebrew/brew release) with the taps.
    brew-src = {
      url = "github:Homebrew/brew/7.0.16";
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
    homebrew-openai-tools = {
      url = "github:openai/homebrew-tools";
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

    # MCP server for the Obsidian vault (home-manager/_mixins/development/brain.nix).
    mcp-brain = {
      url = "github:btravers/mcp-brain";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      # Track the release branch matching nixpkgs (26.05); main targets unstable.
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "aarch64-darwin";
      helpers = import ./lib/helpers.nix { inherit inputs; };
    in
    {
      darwinConfigurations = {
        air = helpers.mkDarwin { hostname = "air"; };
        pro = helpers.mkDarwin { hostname = "pro"; };
        runner = helpers.mkDarwin { hostname = "runner"; };
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
                nix build ".#darwinConfigurations.$(scutil --get LocalHostName).system" --out-link /tmp/nix-darwin-new
                echo "> Comparing with current system..."
                nvd diff /run/current-system /tmp/nix-darwin-new
                rm /tmp/nix-darwin-new
              '';
            })

            self.formatter.${system}
          ];
        };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
