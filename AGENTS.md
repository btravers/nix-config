# Nix-Darwin Configuration - AI Agent Quick Reference

> **⚠️ Note:** This file has been superseded by more comprehensive documentation.  
> Please refer to **[DEVELOPMENT.md](./DEVELOPMENT.md)** for complete architecture guidelines, best practices, and operational instructions.
> 
> **Note:** This file is also accessible as `CLAUDE.md` for backward compatibility.

## Quick Reference

### Apply Configuration

```sh
# Standard method
sudo darwin-rebuild switch --flake ~/.config/nix-darwin

# Using development shell (recommended)
nix develop --command apply-nix-darwin-configuration
```

### Development Commands

```sh
nix develop                                    # Enter dev shell
check-nix-darwin-configuration                 # Validate config
diff-nix-darwin-configuration                  # Preview changes
apply-nix-darwin-configuration                 # Apply config
```

## Documentation

For detailed information, see:

- **[DEVELOPMENT.md](./DEVELOPMENT.md)** - Complete development guide
  - Architecture principles
  - Repository structure
  - Adding tools and machines
  - Troubleshooting
  - Best practices

- **[README.md](./README.md)** - Project overview and quick start

## AI Assistant Context

AI coding assistants should reference [DEVELOPMENT.md](./DEVELOPMENT.md) for:
- Project conventions and patterns
- How to make consistent changes
- Architecture principles
- Common operations
