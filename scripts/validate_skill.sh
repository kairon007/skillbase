#!/usr/bin/env bash

# validate_skill.sh
# Validates the metadata, placeholders, and links of a specific skill.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SKILL_NAME="${1:-}"

if [ -z "$SKILL_NAME" ]; then
    echo "Error: Please specify a skill name." >&2
    echo "Usage: $0 <skill-name>" >&2
    exit 1
fi

SKILL_PATH="$REPO_ROOT/skills/$SKILL_NAME"

if [ ! -d "$SKILL_PATH" ]; then
    echo "Error: Skill directory '$SKILL_PATH' does not exist." >&2
    exit 1
fi

python3 "$SCRIPT_DIR/validate_skill.py" "$SKILL_PATH"
