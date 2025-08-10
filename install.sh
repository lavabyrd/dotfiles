#!/bin/bash

set -e  # Exit on any error

echo "🚀 Setting up dotfiles..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS. Exiting."
    exit 1
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_status "Updating Homebrew..."
brew update

# Install required tools
print_status "Installing required tools..."
tools=(
    "stow"
    "fish"
    "yazi" 
    "zoxide"
    "atuin"
    "eza"
    "lazygit"
    "gh"
    "bitwarden-cli"
    "coreutils"
    "fd"
    "ffmpeg"
    "fzf"
    "gemini-cli"
    "go"
    "imagemagick"
    "jq"
    "kubectx"
    "neovim"
    "poppler"
    "resvg"
    "ripgrep"
    "xh"
)

for tool in "${tools[@]}"; do
    if brew list "$tool" &>/dev/null; then
        print_success "$tool already installed"
    else
        print_status "Installing $tool..."
        brew install "$tool"
    fi
done

# Install cask applications
print_status "Installing cask applications..."
casks=(
    "font-symbols-only-nerd-font"
    "orbstack"
    "podman-desktop"
)

for cask in "${casks[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        print_success "$cask already installed"
    else
        print_status "Installing $cask..."
        brew install --cask "$cask"
    fi
done

# Setup dotfiles with stow
print_status "Setting up configuration symlinks..."
if [[ -f "$(pwd)/config/.config/fish/config.fish" ]]; then
    stow config
    print_success "Configuration symlinks created"
else
    print_error "config/.config/fish/config.fish not found. Are you in the dotfiles directory?"
    exit 1
fi

# Optional: Set fish as default shell
echo
read -p "Set fish as your default shell? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    fish_path=$(which fish)
    
    # Add fish to /etc/shells if not already there
    if ! grep -Fxq "$fish_path" /etc/shells; then
        print_status "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells
    fi
    
    # Change default shell
    print_status "Setting fish as default shell..."
    chsh -s "$fish_path"
    print_success "Fish set as default shell"
else
    print_warning "Skipping fish shell setup"
fi

echo
print_success "🎉 Dotfiles setup complete!"
print_status "Open a new terminal or run 'exec fish' to start using your new configuration"