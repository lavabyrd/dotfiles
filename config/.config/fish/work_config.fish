# Work-specific Fish Configuration
# Source this file from config.fish for work-related settings

# Work-specific Environment Variables
set -gx CITADEL_CONFIG_HOME /Users/markpreston/.config/citadel
set -gx CITADEL_ROOT /Users/markpreston/code/work/citadel
set -gx FIG_LOGIN_AWS_TELEPORT_LOGIN true
set -gx GOPRIVATE github.com/figment-networks
set -gx HELM_DRIVER configmap

# Work-specific Aliases

alias tlgr "tctl get roles --format=json | jq '.[].metadata.name'"
alias ccd "constable citadel dev stop; constable citadel dev start"
alias ccl "constable citadel dev logs -f"

# Work-specific Functions
function hrg
    rg --ignore-case $argv[1] ~/code/work/provisioning/config/hosts
end

function srg
    rg --ignore-case $argv[1] ~/code/work/eth2-syncer
end

function drg
    rg --ignore-case $argv[1] ~/code/work/dockerfiles
end