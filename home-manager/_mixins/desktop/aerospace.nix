{ ... }:
{
  xdg.configFile."aerospace/aerospace.toml" = {
    text = ''
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

      # Main mode bindings. ctrl-alt, not alt: on the French layout alt (Option)
      # types { [ | and other symbols, which plain alt bindings would swallow.
      [mode.main.binding]

      # Focus windows
      ctrl-alt-h = 'focus left'
      ctrl-alt-j = 'focus down'
      ctrl-alt-k = 'focus up'
      ctrl-alt-l = 'focus right'

      # Move windows
      ctrl-alt-shift-h = 'move left'
      ctrl-alt-shift-j = 'move down'
      ctrl-alt-shift-k = 'move up'
      ctrl-alt-shift-l = 'move right'

      # Resize windows
      ctrl-alt-shift-n = 'resize smart -50'
      ctrl-alt-shift-p = 'resize smart +50'

      # Layout commands
      ctrl-alt-t = 'layout tiles horizontal vertical'
      ctrl-alt-s = 'layout accordion horizontal vertical'
      ctrl-alt-f = 'fullscreen'

      # Float
      ctrl-alt-shift-f = 'layout floating tiling'

      # Switch workspaces
      ctrl-alt-1 = 'workspace 1'
      ctrl-alt-2 = 'workspace 2'
      ctrl-alt-3 = 'workspace 3'
      ctrl-alt-4 = 'workspace 4'
      ctrl-alt-5 = 'workspace 5'
      ctrl-alt-6 = 'workspace 6'
      ctrl-alt-7 = 'workspace 7'
      ctrl-alt-8 = 'workspace 8'
      ctrl-alt-9 = 'workspace 9'

      # Cycle through workspaces
      ctrl-alt-tab = 'workspace next'
      ctrl-alt-shift-tab = 'workspace prev'

      # Move windows to workspaces
      ctrl-alt-shift-1 = 'move-node-to-workspace 1'
      ctrl-alt-shift-2 = 'move-node-to-workspace 2'
      ctrl-alt-shift-3 = 'move-node-to-workspace 3'
      ctrl-alt-shift-4 = 'move-node-to-workspace 4'
      ctrl-alt-shift-5 = 'move-node-to-workspace 5'
      ctrl-alt-shift-6 = 'move-node-to-workspace 6'
      ctrl-alt-shift-7 = 'move-node-to-workspace 7'
      ctrl-alt-shift-8 = 'move-node-to-workspace 8'
      ctrl-alt-shift-9 = 'move-node-to-workspace 9'

      # Service mode (for reloading config, etc.)
      ctrl-alt-shift-r = 'mode service'

      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main']
      ctrl-alt-shift-h = ['join-with left', 'mode main']
      ctrl-alt-shift-j = ['join-with down', 'mode main']
      ctrl-alt-shift-k = ['join-with up', 'mode main']
      ctrl-alt-shift-l = ['join-with right', 'mode main']
    '';
  };
}
