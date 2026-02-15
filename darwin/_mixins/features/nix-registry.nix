{ lib, inputs, ... }:

let
  # Filter to only actual flakes (exclude inputs with flake = false like homebrew taps)
  flakeInputs = lib.filterAttrs (_: v: v ? outputs) inputs;
in
{
  # Pin the flake registry so `nix shell nixpkgs#foo` uses locked versions
  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;

  # Legacy <nixpkgs> channel compatibility
  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
}
