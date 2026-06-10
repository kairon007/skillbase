#!/usr/bin/env bash

# unlink_skill.sh
# Safely removes a symlink to a skill.

set -euo pipefail

DEFAULT_TARGET_DIR="/Users/amitkairon/.gemini/config/skills"

SKILL_NAME="${1:-}"
TARGET_DIR="${2:-$DEFAULT_TARGET_DIR}"

if [ -z "$SKILL_NAME" ]; then
    echo "Error: Please specify a skill name." >&2
    echo "Usage: $0 <skill-name> [target-directory]" >&2
    exit 1
fi

TARGET_LINK="$TARGET_DIR/$SKILL_NAME"

if [ ! -e "$TARGET_LINK" ] && [ ! -L "$TARGET_LINK" ]; then
    echo "Info: No symlink or file found at $TARGET_LINK. Nothing to remove."
    exit 0
fi

if [ -L "$TARGET_LINK" ]; then
    echo "Removing symlink: $TARGET_LINK"
    rm "$TARGET_LINK"
    echo "Success! Symlink removed."
else
    echo "Warning: Target '$TARGET_LINK' exists but is NOT a symbolic link. It is a regular file/directory." >&2
    echo "To avoid data loss, this script will not delete it. Please inspect and remove it manually if needed." >&2
    exit 1
fi
