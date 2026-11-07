{ lib, inputs, ... }:

let
  # Filter to only actual flakes (exclude inputs with flake = false like homebrew taps)
  flakeInputs = lib.filterAttrs (_: v: v ? outputs) inputs;
in
{
  # Pin the flake registry so `nix shell nixpkgs#foo` uses locked versions.
  # determinateNix.*, not nix.*: Determinate disables nix-darwin's nix module.
  determinateNix.registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
}
