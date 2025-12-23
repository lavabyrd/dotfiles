if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Environment Variables
set -gx PYENV_ROOT $HOME/.pyenv
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx _ZO_EXCLUDE_DIRS $HOME/code/tickets/*
set -gx GPG_TTY (tty)
set -gx GOOGLE_CLOUD_PROJECT semiotic-karma-442617-p4
set -gx WORKON_HOME $HOME/.virtualenvs
set -gx PROJECT_HOME $HOME/code

# PATH Setup
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/sbin $PATH
set -gx PATH /usr/local/opt/gnu-tar/libexec/gnubin $PATH
set -gx PATH /usr/local/sbin $PATH
set -gx PATH $HOME/.rbenv/bin $PATH
set -gx PATH $HOME/go/bin $PATH
set -gx PATH /usr/local/opt/openssl@1.1/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $PYENV_ROOT/bin $PATH
set -gx PATH $HOME/.atuin/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -U fish_user_paths $fish_user_paths "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"

# Tool Initialization
zoxide init fish | source
eval "$(atuin init fish)"
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Navigation Aliases
alias j z
alias cdold "builtin cd"
alias cd z
alias tn ticket-new

# Config Management Aliases
alias fr "source ~/.config/fish/config.fish"
alias fc "nvim ~/.config/fish/config.fish"
alias tc "nvim ~/.tmux.conf"

# File System Aliases
alias ls "eza --all --all --long --header --git --icons"
alias tree "eza --list --header --git --icons"

# Git Aliases
alias gundo "git reset HEAD~;"
alias gst "git status"
alias gg lazygit
alias gmp "git checkout main && git pull"

function git
    /usr/bin/git $argv
end

# # Disable VCS prompts to fix slowness (temporary until homebrew git is fixed)
# function fish_vcs_prompt
#     # Disabled due to slow homebrew git
#     # To re-enable, remove this function override
# end

# Editor Aliases
alias n nvim
alias vim nvim
alias cur cursor

# Kubernetes Aliases
alias kc kubectx
alias kn kubens

# Teleport
function tsc
    tsh ssh teleport-access@$argv[1]
end

complete -c tsc -f -a "(tsh ls -f names 2>/dev/null)"

# Python Aliases
alias pip pip3
alias penv "source ~/.virtualenvs/.venv/bin/activate"

# Misc Aliases
alias tlint "terraform fmt -recursive"
# Functions
function nd
    mkdir -p -- "$argv[1]"
    and cd "$argv[1]"
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function load_api_keys
    echo "Attempting to load API keys..."

    # Check for 1Password session
    if type -q op
        if op account list --format json >/dev/null 2>&1
            echo "🔑 Found 1Password session. Loading credentials."

            # Correct op read syntax and quote the item name
            set -gx JIRA_API_KEY (op read "op://employee/keys/jira_api_key")
            set -gx OBSIDIAN_API_KEY (op read "op://employee/keys/obsidian_api_key")
            set -gx STREAQ_SIGNATURE_ID (op read "op://employee/keys/streaq_signature_id")

            echo "1Password credentials loaded."
            return 0
        end
    end

    # Check for Bitwarden session
    if type -q bw
        set -l bw_status (bw status | jq -r .status)
        if test $bw_status = unlocked
            echo "🔑 Found unlocked Bitwarden session. Syncing vault..."
        else if test $bw_status = locked
            echo "🔒 Bitwarden vault is locked. Please unlock it to proceed."
            bw unlock --raw --check >/dev/null # This prompts you for your master password
        else
            echo "🚫 Bitwarden session not found or status is unknown. Please log in first with 'bw login'."
            return 1
        end

        # Now that the vault is unlocked, we can sync and load
        bw sync --quiet

        # Load secrets from the updated vault
        set -l ITEM_JSON (bw get item "keys")
        if not set -q ITEM_JSON
            echo "⚠️ Item 'keys' not found in Bitwarden."
            return 1
        end

        set -gx OBSIDIAN_API_KEY (echo $ITEM_JSON | jq -r '.fields[] | select(.name=="obsidian_api_key") | .value')
        echo "Bitwarden credentials loaded."
        return 0
    end

    echo "🚫 No active 1Password or Bitwarden session found. Please log in."
    return 1
end

# Load work-specific configuration if it exists
if test -f ~/.config/fish/work_config.fish
    source ~/.config/fish/work_config.fish
end
