#!/bin/bash

echo "🧪 Testing dotfiles setup..."

FAILED=0

# Test symlinks
echo "Checking symlinks..."
configs=("fish" "yazi" "lazygit" "git" "gh" "atuin" "nvim")

for config in "${configs[@]}"; do
    if [[ -L "$HOME/.config/$config" ]]; then
        target=$(readlink "$HOME/.config/$config")
        echo "✅ $config -> $target"
    else
        echo "❌ $config is not symlinked"
        ((FAILED++))
    fi
done

# Test Claude configuration symlinks
echo -e "\nChecking Claude configuration..."
claude_items=("settings.json" "CLAUDE.md" "commands" "agents")

for item in "${claude_items[@]}"; do
    if [[ -L "$HOME/.claude/$item" ]]; then
        target=$(readlink "$HOME/.claude/$item")
        echo "✅ .claude/$item -> $target"
    else
        echo "❌ .claude/$item is not symlinked"
        ((FAILED++))
    fi
done

# Test files exist
echo -e "\nChecking dotfiles structure..."
files=(
    "$HOME/dotfiles/install.sh"
    "$HOME/dotfiles/test.sh"
    "$HOME/dotfiles/.gitignore"
    "$HOME/dotfiles/README.md"
    "$HOME/dotfiles/config/.config/fish/config.fish"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $(basename "$file") exists"
    else
        echo "❌ $(basename "$file") missing"
        ((FAILED++))
    fi
done

# Test tools
echo -e "\nChecking required tools..."
tools=("stow" "fish" "yazi" "zoxide" "atuin" "eza" "lazygit" "gh" "nvim")

for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null; then
        echo "✅ $tool is installed"
    else
        echo "❌ $tool is missing"
        ((FAILED++))
    fi
done

echo -e "\n📊 Test Results:"
if [[ $FAILED -eq 0 ]]; then
    echo "🎉 All tests passed! Dotfiles setup is working correctly."
    exit 0
else
    echo "❌ $FAILED test(s) failed."
    exit 1
fi