#!/bin/bash

set -e # Exit on any error

# Parse command line arguments
INSTALL_HOMEBREW=true
INSTALL_TOOLS=true
INSTALL_CASKS=true
SETUP_STOW=true
STOW_PACKAGES=""
HELP=false

# Check for help flag anywhere in arguments
for arg in "$@"; do
  if [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
    HELP=true
    break
  fi
done

if [[ "$HELP" == true ]]; then
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --stow-only              Only setup stow symlinks, skip homebrew/tools/casks"
  echo "  --tools-only             Only install homebrew tools, skip stow setup"
  echo "  --stow-packages PKGS     Only stow specific packages (comma-separated)"
  echo "                          Available: gh,nvim,lazygit,yazi,atuin,fish,git"
  echo "  --no-homebrew           Skip homebrew installation"
  echo "  --no-tools              Skip tool installation"
  echo "  --no-casks              Skip cask installation"
  echo "  --no-stow               Skip stow setup"
  echo "  -h, --help              Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --stow-only                    # Only setup stow symlinks"
  echo "  $0 --stow-packages fish,git       # Only stow fish and git configs"
  echo "  $0 --tools-only                   # Only install tools"
  echo "  $0 --no-casks                     # Skip cask apps"
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      shift
      ;;
    --stow-packages)
      if [[ -z "$2" || "$2" =~ ^-- ]]; then
        echo "Error: --stow-packages requires a comma-separated list of packages"
        exit 1
      fi
      STOW_PACKAGES="$2"
      # When specifying specific stow packages, default to stow-only behavior
      INSTALL_HOMEBREW=false
      INSTALL_TOOLS=false
      INSTALL_CASKS=false
      shift 2
      ;;
    --stow-only)
      INSTALL_HOMEBREW=false
      INSTALL_TOOLS=false
      INSTALL_CASKS=false
      shift
      ;;
    --tools-only)
      SETUP_STOW=false
      shift
      ;;
    --no-homebrew)
      INSTALL_HOMEBREW=false
      shift
      ;;
    --no-tools)
      INSTALL_TOOLS=false
      shift
      ;;
    --no-casks)
      INSTALL_CASKS=false
      shift
      ;;
    --no-stow)
      SETUP_STOW=false
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

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
if [[ "$INSTALL_HOMEBREW" == true ]]; then
  if ! command -v brew &>/dev/null; then
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
else
  print_status "Skipping Homebrew installation"
fi

# Install tools and casks via Brewfile
if [[ "$INSTALL_TOOLS" == true || "$INSTALL_CASKS" == true ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BREWFILE="$SCRIPT_DIR/Brewfile"

  if [[ -f "$BREWFILE" ]]; then
    print_status "Installing packages from Brewfile..."

    # Build brew bundle arguments based on flags
    BUNDLE_ARGS=""
    if [[ "$INSTALL_TOOLS" != true ]]; then
      BUNDLE_ARGS="$BUNDLE_ARGS --no-brew"
    fi
    if [[ "$INSTALL_CASKS" != true ]]; then
      BUNDLE_ARGS="$BUNDLE_ARGS --no-cask"
    fi

    if brew bundle --file="$BREWFILE" $BUNDLE_ARGS; then
      print_success "Brewfile packages installed"
    else
      print_warning "Some Brewfile packages may have failed to install"
    fi
  else
    print_error "Brewfile not found at $BREWFILE"
    exit 1
  fi
else
  print_status "Skipping tool and cask installation"
fi

# Setup dotfiles with stow
if [[ "$SETUP_STOW" == true ]]; then
  print_status "Setting up configuration symlinks..."
  
  # Check if we're in the right directory
  if [[ ! -d "$(pwd)/config/.config" ]]; then
    print_error "config/.config directory not found. Are you in the dotfiles directory?"
    exit 1
  fi
  
  # Check if stow is available
  if ! command -v stow &>/dev/null; then
    print_error "stow is not installed. Please install it first or run without --stow-only"
    exit 1
  fi
  
  # Available stow packages based on directory structure
  available_packages=()
  for dir in config/.config/*/; do
    if [[ -d "$dir" ]]; then
      package=$(basename "$dir")
      available_packages+=("$package")
    fi
  done
  
  # Determine which packages to stow
  if [[ -n "$STOW_PACKAGES" ]]; then
    # Parse comma-separated package list
    IFS=',' read -ra packages_to_stow <<< "$STOW_PACKAGES"
    
    # Validate requested packages exist
    for pkg in "${packages_to_stow[@]}"; do
      if [[ ! -d "config/.config/$pkg" ]]; then
        print_error "Package '$pkg' not found. Available packages: ${available_packages[*]}"
        exit 1
      fi
    done
    
    print_status "Stowing specific packages: ${packages_to_stow[*]}"
    
    # Create the target directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Manually create symlinks for each package
    for package in "${packages_to_stow[@]}"; do
      source_path="$(pwd)/config/.config/$package"
      target_path="$HOME/.config/$package"
      
      
      if [[ -e "$target_path" || -L "$target_path" ]]; then
        print_warning "$package already exists in ~/.config (skipping)"
        continue
      fi
      
      if [[ ! -d "$source_path" ]]; then
        print_error "Source directory $source_path does not exist"
        continue
      fi
      
      if ln -sf "$source_path" "$target_path"; then
        print_success "Stowed $package"
      else
        print_warning "Failed to stow $package"
      fi
    done
  else
    # Stow all configurations at once
    print_status "Stowing all configurations"
    
    # Create the target directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Stow the config package (which contains .config directory)
    if stow -d "$(pwd)" -t "$HOME" config 2>/dev/null; then
      print_success "Stowed all configurations"
    else
      print_warning "Failed to stow configurations (may already exist or have conflicts)"
      print_status "You may need to remove existing files/symlinks in ~/.config first"
    fi
  fi
  
  # Setup Claude configuration symlinks
  CLAUDE_SRC="$(pwd)/claude/.claude"
  if [[ -d "$CLAUDE_SRC" ]]; then
    print_status "Setting up Claude configuration..."
    mkdir -p "$HOME/.claude"

    for item in settings.json CLAUDE.md commands agents; do
      if [[ -e "$CLAUDE_SRC/$item" ]]; then
        if ln -sf "$CLAUDE_SRC/$item" "$HOME/.claude/$item"; then
          print_success "Linked Claude $item"
        else
          print_warning "Failed to link Claude $item"
        fi
      fi
    done
  fi
  
  print_success "Configuration symlinks setup complete"
else
  print_status "Skipping stow configuration"
fi

# Optional: Set fish as default shell (only if tools were installed)
if [[ "$INSTALL_TOOLS" == true ]] && command -v fish &>/dev/null; then
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
fi

echo
print_success "🎉 Dotfiles setup complete!"
if [[ "$INSTALL_TOOLS" == true ]] && command -v fish &>/dev/null; then
  print_status "Open a new terminal or run 'exec fish' to start using your new configuration"
fi

