{ username, ... }:
{
  system.defaults.screencapture = {
    disable-shadow = true;
    type = "png";
    location = "~/Screenshots";
  };

  # screencapture won't create the target directory itself.
  home-manager.users.${username}.home.file."Screenshots/.keep".text = "";
}
