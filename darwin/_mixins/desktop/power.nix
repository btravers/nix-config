{ ... }:
{
  # "Prevent automatic sleeping on power adapter when the display is off":
  # on the charger (-c) the Mac never sleeps, so background jobs keep running.
  # Battery sleep stays macOS's default. power.sleep.computer would hit both.
  system.activationScripts.postActivation.text = ''
    pmset -c sleep 0
  '';
}
