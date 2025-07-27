#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
LOCAL_CONFIG_DIR="$HOME/nix-server"
SERVER_USER="zachary"
SERVER_HOST="192.168.50.62"
REMOTE_CONFIG_DIR="/home/${SERVER_USER}/nix-server"
# --- End Configuration ---

# --- Argument Parsing Logic ---
declare -a valid_commands
valid_commands=(switch boot test build dry-activate build-vm build-vm-with-bootloader build-image edit)

show_usage() {
    echo "Usage: $0 [command] [flags...]"
    echo "Valid commands: ${valid_commands[*]}"
    echo "Special flags:"
    echo "  --gc             Run garbage collection on the server before rebuilding."
    echo "  --upflake        Update flake inputs LOCALLY before syncing."
}

is_in_array() {
    local needle="$1"; shift; local haystack=("$@")
    for item in "${haystack[@]}"; do [[ "$item" == "$needle" ]] && return 0; done
    return 1
}

declare -a rebuild_args
rebuild_command=""
run_garbage_collection=false
update_flake_inputs=false

if [[ $# -eq 0 ]]; then
    rebuild_command="switch"
else
    for arg in "$@"; do
        case $arg in
            --gc) run_garbage_collection=true ;;
            --upflake) update_flake_inputs=true ;;
            *)
                if [[ -z "$rebuild_command" ]]; then
                    rebuild_command="$arg"
                else
                    rebuild_args+=("$arg")
                fi
                ;;
        esac
    done
    [[ -z "$rebuild_command" ]] && rebuild_command="switch"
fi

if ! is_in_array "$rebuild_command" "${valid_commands[@]}"; then
    echo "❌ Error: Invalid rebuild command: '$rebuild_command'"
    show_usage
    exit 1
fi

# --- Execution Flow ---

# 1. (NEW) Update local flake inputs if --upflake is used
if [[ "$update_flake_inputs" == true ]]; then
    echo "❄️  Updating local flake inputs at '$LOCAL_CONFIG_DIR'..."
    cd "$LOCAL_CONFIG_DIR"
    nix flake update
    cd - > /dev/null # Go back to the previous directory silently
    echo "✅ Flake inputs updated locally."
fi

# 2. Sync local configuration to the server
echo "🔄 Syncing local config to '$SERVER_HOST'..."
rsync -av --delete --exclude='.git/' --exclude='result' "$LOCAL_CONFIG_DIR/" "${SERVER_USER}@${SERVER_HOST}:${REMOTE_CONFIG_DIR}/"
echo "✅ Sync complete."

# 3. Build the sequence of commands to run on the server
server_commands=""
if [[ "$run_garbage_collection" == true ]]; then
    server_commands+="sudo nix-collect-garbage -d && "
fi
server_commands+="bash ${REMOTE_CONFIG_DIR}/rebuild.sh $rebuild_command ${rebuild_args[*]}"

# 4. (MODIFIED) Connect, execute, and handle Git commit on success
echo -e "\n🚀 Connecting to server to execute rebuild..."
echo "================================================="
if ssh -t "${SERVER_USER}@${SERVER_HOST}" "$server_commands"; then
    echo -e "\n✅ Remote rebuild successful!"

    # --- New Git Commit Logic ---
    cd "$LOCAL_CONFIG_DIR"
    echo "💾 Adding all changes to git..."
    git add .

    # Prompt for a commit message
    echo -n "Enter a commit message (or press Enter for default): "
    read -r user_message

    # Use default message if input is empty
    if [[ -z "$user_message" ]]; then
        commit_message="nixos: build $(date +"%Y-%m-%d %H:%M:%S")"
        echo "Using default commit message: '$commit_message'"
    else
        commit_message="$user_message"
    fi

    git commit -m "$commit_message"
    echo "🚀 Pushing changes..."
    git push

else
    echo -e "\n❌ Remote rebuild failed."
    exit 1
fi