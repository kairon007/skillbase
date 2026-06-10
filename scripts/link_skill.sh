#!/usr/bin/env bash

# link_skill.sh
# Symlinks a skill from skills/ to the AI agent config directory or a custom path.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
DEFAULT_TARGET_DIR="/Users/amitkairon/.gemini/config/skills"

SKILL_NAME="${1:-}"
TARGET_DIR="${2:-$DEFAULT_TARGET_DIR}"

if [ -z "$SKILL_NAME" ]; then
    echo "Error: Please specify a skill name." >&2
    echo "Usage: $0 <skill-name> [target-directory]" >&2
    exit 1
fi

SOURCE_SKILL="$SKILLS_DIR/$SKILL_NAME"

if [ ! -d "$SOURCE_SKILL" ]; then
    echo "Error: Skill '$SKILL_NAME' not found in $SKILLS_DIR." >&2
    exit 1
fi

if [ ! -f "$SOURCE_SKILL/SKILL.md" ]; then
    echo "Warning: Skill '$SKILL_NAME' exists but does not contain a SKILL.md file." >&2
fi

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

TARGET_LINK="$TARGET_DIR/$SKILL_NAME"

echo "Creating symlink..."
echo "Source: $SOURCE_SKILL"
echo "Target: $TARGET_LINK"

# Create symbolic link, replacing existing link or directory if it matches
ln -snf "$SOURCE_SKILL" "$TARGET_LINK"

echo "Success! Skill '$SKILL_NAME' is now symlinked."
echo "Verify link details:"
ls -la "$TARGET_LINK"
