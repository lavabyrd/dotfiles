# Dotfiles

Personal dotfiles for development environment configuration on macOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management and [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) for reproducible tool installation.

## Quick Start

### One-Command Install
```bash
curl -sSL https://raw.githubusercontent.com/lavabyrd/dotfiles/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/lavabyrd/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

## What Gets Installed

### CLI Tools (via Brewfile)
| Tool | Description |
|------|-------------|
| fish | Friendly interactive shell |
| neovim | Hyperextensible Vim-based text editor |
| lazygit | Terminal UI for git |
| gh | GitHub CLI |
| yazi | Terminal file manager |
| zoxide | Smart directory jumping |
| atuin | Shell history sync and search |
| eza | Modern ls replacement |
| fzf | Fuzzy finder |
| ripgrep | Fast grep alternative |
| fd | Fast find alternative |
| jq | JSON processor |
| xh | HTTP client |
| bitwarden-cli | Password manager CLI |

### Cask Applications
- **Ghostty** - GPU-accelerated terminal
- **OrbStack** - Docker/Linux on macOS
- **Nerd Font Symbols** - Icon font for terminal

## Configurations

| Config | Description |
|--------|-------------|
| fish | Shell config with aliases, functions, Bitwarden SSH agent |
| nvim | LazyVim setup with plugins |
| lazygit | Git TUI configuration |
| yazi | File manager with vim keybindings |
| atuin | Shell history settings |
| git | Global git config and templates |
| gh | GitHub CLI settings |
| .claude | Claude Code permissions and settings |

## Post-Install Setup

### Set Fish as Default Shell
```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### SSH with Bitwarden
1. Enable SSH Agent in Bitwarden Desktop (Settings → SSH Agent)
2. Add your SSH key to Bitwarden (Item type: SSH Key)
3. The fish config automatically points to Bitwarden's SSH agent socket

### Git SSH Signing
```bash
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global user.signingkey "key::ssh-ed25519 YOUR_PUBLIC_KEY"
```

## Install Options

```bash
./install.sh --help              # Show all options
./install.sh --stow-only         # Only create symlinks
./install.sh --tools-only        # Only install Homebrew tools
./install.sh --no-casks          # Skip cask applications
./install.sh --stow-packages fish,nvim  # Stow specific configs only
```

## Adding New Tools

Edit `Brewfile` to add new tools, then run:
```bash
brew bundle --file=~/dotfiles/Brewfile
```
