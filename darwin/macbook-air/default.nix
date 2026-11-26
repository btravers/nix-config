{ inputs, ... }:
{
  nix-homebrew.taps."TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
  homebrew.casks = [ "TheBoredTeam/boring-notch/boring-notch" ];
}
