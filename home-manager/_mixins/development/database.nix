{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Database CLI clients
    postgresql # psql - for quick queries even when using IntelliJ GUI
    sqlite # sqlite3 - useful for local dev and scripts
  ];
}
