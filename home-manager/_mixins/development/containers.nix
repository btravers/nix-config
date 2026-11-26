{ pkgs, ... }:
{
  # Colima runs dockerd in a lightweight Lima VM (launchd agent, starts at login)
  # and sets DOCKER_HOST, so docker, compose, tilt and testcontainers just work.
  services.colima = {
    enable = true;
    profiles.default = {
      isActive = true;
      isService = true;
      setDockerHost = true;
      settings = {
        vmType = "vz";
        rosetta = true;
        mountType = "virtiofs";
      };
    };
  };

  home.packages = with pkgs; [
    docker-client
    docker-compose
  ];

  programs.docker-cli = {
    enable = true;
    settings.cliPluginsExtraDirs = [ "${pkgs.docker-compose}/libexec/docker/cli-plugins" ];
  };
}
