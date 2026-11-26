{
  config,
  lib,
  pkgs,
  ...
}:
let
  jq = lib.getExe pkgs.jq;
  # Agents that own (and write to) their config files get servers through their
  # own CLI or a jq merge. Zed and opencode read programs.mcp.servers directly.
  register =
    name: s:
    let
      n = lib.escapeShellArg name;
      want = lib.escapeShellArg (builtins.toJSON { inherit (s) command args; });
      claudeJson = lib.escapeShellArg (
        builtins.toJSON {
          type = "stdio";
          inherit (s) command args;
        }
      );
      codexArgs = lib.escapeShellArgs ([ s.command ] ++ s.args);
    in
    ''
      # Claude Code: user scope in ~/.claude.json
      if [ -x "$claude" ] && [ "$(${jq} -cS --arg n ${n} '.mcpServers[$n] // {} | {command, args}' "$HOME/.claude.json" 2>/dev/null)" != "$(${jq} -cS . <<< ${want})" ]; then
        run "$claude" mcp remove --scope user ${n} >/dev/null 2>&1 || true
        run "$claude" mcp add-json --scope user ${n} ${claudeJson} >/dev/null \
          || warnEcho "mcp: could not register ${name} with Claude Code"
      fi

      # Codex: ~/.codex/config.toml
      if [ -x "$codex" ]; then
        run "$codex" mcp remove ${n} >/dev/null 2>&1 || true
        run "$codex" mcp add ${n} -- ${codexArgs} >/dev/null \
          || warnEcho "mcp: could not register ${name} with Codex"
      fi

      # Claude Desktop
      if [ -d "$(dirname "$desktop")" ]; then
        tmp=$(mktemp)
        if { cat "$desktop" 2>/dev/null || echo '{}'; } \
            | ${jq} --arg n ${n} --argjson s ${want} '.mcpServers[$n] = $s' > "$tmp" \
            && ! cmp -s "$tmp" "$desktop"; then
          run mv "$tmp" "$desktop"
        else
          rm -f "$tmp"
        fi
      fi
    '';
in
{
  programs.mcp.enable = true;

  home.activation.registerMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    claude="$HOME/.local/bin/claude"
    codex="$HOME/.local/bin/codex"
    desktop="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    ${lib.concatStrings (lib.mapAttrsToList register config.programs.mcp.servers)}
  '';
}
