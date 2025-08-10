if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Environment Variables
set -gx PYENV_ROOT $HOME/.pyenv
set -gx XDG_CONFIG_HOME $HOME/.config
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
set -U fish_user_paths $fish_user_paths "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"

# Tool Initialization
zoxide init fish | source
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish
eval "$(atuin init fish)"
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Navigation Aliases
alias j z
alias cdold "builtin cd"
alias cd z

# Config Management Aliases
alias fr "source ~/.config/fish/config.fish"
alias fc "nvim ~/.config/fish/config.fish"
alias nc "nvim ~/.config/nvim/init.lua"
alias tc "nvim ~/.tmux.conf"

# File System Aliases
alias ls "eza --all --all --long --header --git --icons"
alias tree "eza --list --header --git --icons"

# Git Aliases
alias gundo "git reset HEAD~;"
alias gst "git status"
alias gg lazygit

# Editor Aliases
alias n nvim
alias vim nvim
alias cur cursor

# Kubernetes Aliases
alias kc kubectx
alias kn kubens

# Python Aliases
alias pip pip3
alias penv "source ~/.virtualenvs/.venv/bin/activate"

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

