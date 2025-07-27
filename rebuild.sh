#!/usr/bin/env bash

set -euo pipefail
#  Scripts expects the first argument to be a valid nixos-rebuild command sent by deployment

REBUILD_COMMAND="$1"
shift # Remove the command from the arguments list
REBUILD_ARGS=("$@") # The rest are arguments for nixos-rebuild

CONFIG_DIR="$HOME/nix-server"

echo "--- Starting NixOS Rebuild on Server ---"

# 1. Create a temporary backup of the current system configuration
backup_dir=$(mktemp -d)
echo "🛡️  Creating backup of /etc/nixos in $backup_dir"
if [[ -d /etc/nixos ]]; then
    sudo cp -r /etc/nixos "$backup_dir"
fi

# 2. Sync the user's config to the system-wide location
echo "📂 Syncing '$CONFIG_DIR/' to '/etc/nixos/'..."
sudo mkdir -p /etc/nixos
sudo rsync -a --delete --exclude='.git/' "$CONFIG_DIR/" /etc/nixos/

# 3. Change to the system directory and execute the rebuild
cd /etc/nixos
hostname=$(hostname)
echo " rebuilding with: nixos-rebuild $REBUILD_COMMAND --flake .#$hostname ${REBUILD_ARGS[*]}"

# Use an array to safely handle arguments with spaces
rebuild_cmd=(sudo nixos-rebuild "$REBUILD_COMMAND" --flake ".#$hostname" "${REBUILD_ARGS[@]}")

if "${rebuild_cmd[@]}"; then
    echo "✅ Rebuild successful."
    sudo rm -rf "$backup_dir"
    exit 0
else
    echo "❌ Rebuild failed! Restoring previous configuration from backup..."
    if [[ -d "$backup_dir/nixos" ]]; then
      sudo rm -rf /etc/nixos
      sudo cp -r "$backup_dir/nixos" /etc/
    fi
    echo "🛡️  Previous configuration restored."
    exit 1
fi