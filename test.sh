#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_test() {
    echo -e "${YELLOW}[TEST]${NC} $1"
    ((TESTS_RUN++))
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

# Test function
test_symlink() {
    local config_path="$1"
    local expected_target="$2"
    
    print_test "Checking symlink: $config_path"
    
    if [[ -L "$config_path" ]]; then
        local actual_target=$(readlink "$config_path")
        if [[ "$actual_target" == "$expected_target" ]]; then
            print_pass "✓ $config_path correctly symlinked to $expected_target"
            return 0
        else
            print_fail "✗ $config_path links to $actual_target, expected $expected_target"
            return 1
        fi
    else
        print_fail "✗ $config_path is not a symlink"
        return 1
    fi
}

test_file_exists() {
    local file_path="$1"
    local description="$2"
    
    print_test "Checking file exists: $description"
    
    if [[ -f "$file_path" ]]; then
        print_pass "✓ $file_path exists"
        return 0
    else
        print_fail "✗ $file_path does not exist"
        return 1
    fi
}

test_command_available() {
    local command="$1"
    
    print_test "Checking command available: $command"
    
    if command -v "$command" &> /dev/null; then
        print_pass "✓ $command is available"
        return 0
    else
        print_fail "✗ $command is not available"
        return 1
    fi
}

test_fish_config() {
    print_test "Testing fish configuration syntax"
    
    if timeout 10 fish -n ~/.config/fish/config.fish 2>/dev/null; then
        print_pass "✓ Fish config syntax is valid"
        return 0
    else
        print_fail "✗ Fish config has syntax errors or timed out"
        return 1
    fi
}

# Start testing
echo -e "${BLUE}🧪 Dotfiles Test Suite${NC}"
echo "Testing dotfiles configuration..."

print_header "Symlink Tests"

# Test all expected symlinks
test_symlink "$HOME/.config/fish" "../dotfiles/config/.config/fish"
test_symlink "$HOME/.config/yazi" "../dotfiles/config/.config/yazi"
test_symlink "$HOME/.config/lazygit" "../dotfiles/config/.config/lazygit"
test_symlink "$HOME/.config/git" "../dotfiles/config/.config/git"
test_symlink "$HOME/.config/gh" "../dotfiles/config/.config/gh"
test_symlink "$HOME/.config/atuin" "../dotfiles/config/.config/atuin"
test_symlink "$HOME/.config/nvim" "../dotfiles/config/.config/nvim"
test_symlink "$HOME/.config/.claude" "../dotfiles/config/.config/.claude"

print_header "File Structure Tests"

# Test dotfiles structure
test_file_exists "$HOME/dotfiles/install.sh" "install script"
test_file_exists "$HOME/dotfiles/.gitignore" "gitignore file"
test_file_exists "$HOME/dotfiles/README.md" "README file"
test_file_exists "$HOME/dotfiles/config/.config/fish/config.fish" "fish config in dotfiles"
test_file_exists "$HOME/dotfiles/config/.config/yazi/yazi.toml" "yazi config in dotfiles"

print_header "Tool Availability Tests"

# Test required tools are installed
test_command_available "stow"
test_command_available "fish"
test_command_available "yazi"
test_command_available "zoxide"
test_command_available "atuin"
test_command_available "eza"
test_command_available "lazygit"
test_command_available "gh"
test_command_available "nvim"

print_header "Configuration Tests"

# Test fish config
test_fish_config

# Test fish aliases work
print_test "Testing fish aliases"
if timeout 10 fish -c "alias j" 2>/dev/null | grep -q "z"; then
    print_pass "✓ Fish zoxide alias 'j' is configured"
else
    print_fail "✗ Fish zoxide alias 'j' is not configured"
fi

# Test yazi config
print_test "Testing yazi configuration"
if [[ -f "$HOME/.config/yazi/yazi.toml" ]]; then
    print_pass "✓ Yazi configuration is accessible"
else
    print_fail "✗ Yazi configuration is not accessible"
fi

# Test git dotfiles repo
print_header "Git Repository Tests"

print_test "Checking if dotfiles is a git repository"
if [[ -d "$HOME/dotfiles/.git" ]]; then
    print_pass "✓ Dotfiles is a git repository"
else
    print_fail "✗ Dotfiles is not a git repository"
fi

# Test git status
print_test "Checking git status"
cd "$HOME/dotfiles"
if git status &>/dev/null; then
    print_pass "✓ Git repository is healthy"
else
    print_fail "✗ Git repository has issues"
fi

print_header "Security Tests"

# Test .gitignore protects sensitive files
print_test "Testing .gitignore protects sensitive files"
if grep -q "hosts.yml" "$HOME/dotfiles/.gitignore"; then
    print_pass "✓ .gitignore protects GitHub hosts file"
else
    print_fail "✗ .gitignore does not protect GitHub hosts file"
fi

# Final results
print_header "Test Results"
echo -e "Tests run: ${TESTS_RUN}"
echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 All tests passed! Your dotfiles setup is working correctly.${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed. Please check the output above.${NC}"
    exit 1
fi