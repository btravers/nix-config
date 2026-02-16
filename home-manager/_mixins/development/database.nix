{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Database CLI clients
    postgresql # psql - for quick queries to containerized databases
    
    # Note: Using PostgreSQL containers via Docker Compose + Tilt
    # psql connects to containers when needed
  ];
}
