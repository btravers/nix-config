{ lib, pkgs, ... }:
{
  # Determinate disables nix-darwin's nix.gc. Weekly, as root: drop system and
  # user generations older than 14 days (keeping the last 5), then collect garbage.
  launchd.daemons.nh-clean = {
    command = "${lib.getExe pkgs.nh} clean all --keep-since 14d --keep 5";
    path = [ "/nix/var/nix/profiles/default" ];
    serviceConfig.StartCalendarInterval = [
      {
        Weekday = 0;
        Hour = 12;
        Minute = 0;
      }
    ];
  };
}
