{ config, lib, ... }:
let
  m = config.aerospace.modifier;
in
{
  options.aerospace.modifier = lib.mkOption {
    type = lib.types.str;
    default = "ctrl-alt";
    description = ''
      Modifier for every AeroSpace binding, set per host to suit its keyboard
      layout. ctrl-alt by default: on French, alt (Option) types { [ | ~, which
      plain alt bindings would swallow. US hosts can use plain alt.
    '';
  };

  config.xdg.configFile."aerospace/aerospace.toml" = {
    text = ''
      config-version = 2

      # Workspaces 1-9 stay alive even when empty. config-version 1 inferred
      # this from the bindings; version 2 needs it spelled out.
      persistent-workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

      after-login-command = []
      after-startup-command = []

      # Start AeroSpace at login
      start-at-login = true

      # Use tiling layout by default
      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'

      # Normalizations
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      # Accordion layout padding
      accordion-padding = 30

      # Mouse follows focus
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # Gaps
      [gaps]
      inner.horizontal = 10
      inner.vertical = 10
      outer.left = 10
      outer.bottom = 10
      outer.top = 10
      outer.right = 10

      # Main mode bindings. The modifier is per host (aerospace.modifier).
      [mode.main.binding]

      # Focus windows
      ${m}-h = 'focus left'
      ${m}-j = 'focus down'
      ${m}-k = 'focus up'
      ${m}-l = 'focus right'

      # Move windows
      ${m}-shift-h = 'move left'
      ${m}-shift-j = 'move down'
      ${m}-shift-k = 'move up'
      ${m}-shift-l = 'move right'

      # Resize windows
      ${m}-shift-n = 'resize smart -50'
      ${m}-shift-p = 'resize smart +50'

      # Layout commands
      ${m}-t = 'layout tiles horizontal vertical'
      ${m}-s = 'layout accordion horizontal vertical'
      ${m}-f = 'fullscreen'

      # Float
      ${m}-shift-f = 'layout floating tiling'

      # Switch workspaces
      ${m}-1 = 'workspace 1'
      ${m}-2 = 'workspace 2'
      ${m}-3 = 'workspace 3'
      ${m}-4 = 'workspace 4'
      ${m}-5 = 'workspace 5'
      ${m}-6 = 'workspace 6'
      ${m}-7 = 'workspace 7'
      ${m}-8 = 'workspace 8'
      ${m}-9 = 'workspace 9'

      # Cycle through workspaces
      ${m}-tab = 'workspace next'
      ${m}-shift-tab = 'workspace prev'

      # Move windows to workspaces
      ${m}-shift-1 = 'move-node-to-workspace 1'
      ${m}-shift-2 = 'move-node-to-workspace 2'
      ${m}-shift-3 = 'move-node-to-workspace 3'
      ${m}-shift-4 = 'move-node-to-workspace 4'
      ${m}-shift-5 = 'move-node-to-workspace 5'
      ${m}-shift-6 = 'move-node-to-workspace 6'
      ${m}-shift-7 = 'move-node-to-workspace 7'
      ${m}-shift-8 = 'move-node-to-workspace 8'
      ${m}-shift-9 = 'move-node-to-workspace 9'

      # Service mode (for reloading config, etc.)
      ${m}-shift-r = 'mode service'

      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main']
      ${m}-shift-h = ['join-with left', 'mode main']
      ${m}-shift-j = ['join-with down', 'mode main']
      ${m}-shift-k = ['join-with up', 'mode main']
      ${m}-shift-l = ['join-with right', 'mode main']
    '';
  };
}
