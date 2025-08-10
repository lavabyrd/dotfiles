# Dotfiles

Personal dotfiles for development environment configuration on macOS and Linux. Uses [GNU Stow](https://www.gnu.org/software/stow/) for portable symlink management.

## Setup

### One-Command Install
```bash
curl -sSL https://raw.githubusercontent.com/lavabyrd/dotfiles/main/install.sh | bash
```

### Manual Install
```bash
# Clone and run install script
git clone https://github.com/lavabyrd/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

### Testing
```bash
# Run tests to verify setup
cd ~/dotfiles && ./test-simple.sh
```

## Configurations

- **fish**: Shell configuration with aliases, functions, and tool initialization
- **yazi**: Terminal file manager with vim-like keybindings and zoxide integration
- **lazygit**: Terminal-based Git client configuration
- **git**: Global Git configuration and templates
- **gh**: GitHub CLI configuration
- **atuin**: Shell history preferences and UI settings
- **nvim**: LazyVim configuration with plugins and settings
- **.claude**: Claude Code permissions, environment, and status line settings

## Tools Integration

- **zoxide**: Smart directory jumping (initialized in fish config)
- **atuin**: Shell history sync and search
- **eza**: Modern ls replacement with Git integration
- **nvim**: LazyVim configuration (separate repo/directory)

