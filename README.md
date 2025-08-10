# Dotfiles

Personal dotfiles for development environment configuration on macOS and Linux. Uses [GNU Stow](https://www.gnu.org/software/stow/) for portable symlink management.

## Setup

```bash
cd ~ && git clone https://github.com/yourusername/dotfiles.git
cd dotfiles && stow config
```

## Configurations

- **fish**: Shell configuration with aliases, functions, and tool initialization
- **yazi**: Terminal file manager with vim-like keybindings and zoxide integration
- **lazygit**: Terminal-based Git client configuration
- **git**: Global Git configuration and templates
- **gh**: GitHub CLI configuration
- **atuin**: Shell history preferences and UI settings

## Tools Integration

- **zoxide**: Smart directory jumping (initialized in fish config)
- **atuin**: Shell history sync and search
- **eza**: Modern ls replacement with Git integration
- **nvim**: LazyVim configuration (separate repo/directory)

