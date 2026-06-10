#!/usr/bin/env bash

# create_skill.sh
# Creates a new skill from the default-skill template.

set -euo pipefail

# Get absolute path of this script's directory to resolve paths correctly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES_DIR="$REPO_ROOT/.templates"
SKILLS_DIR="$REPO_ROOT/skills"

# 1. Get skill name
SKILL_NAME="${1:-}"

if [ -z "$SKILL_NAME" ]; then
    echo -n "Enter skill name (kebab-case, e.g. web-app-builder): "
    read -r SKILL_NAME
fi

# Sanitize skill name: lowercase, convert spaces/underscores to dashes, remove invalid chars
SKILL_NAME=$(echo "$SKILL_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[ _]/-/g' | sed 's/[^a-z0-9-]//g')

if [ -z "$SKILL_NAME" ]; then
    echo "Error: Skill name cannot be empty." >&2
    exit 1
fi

TARGET_SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$TARGET_SKILL_DIR" ]; then
    echo "Error: Skill '$SKILL_NAME' already exists at $TARGET_SKILL_DIR." >&2
    exit 1
fi

# 2. Get description
SKILL_DESC="${2:-}"
if [ -z "$SKILL_DESC" ]; then
    echo -n "Enter skill description (one sentence): "
    read -r SKILL_DESC
fi

if [ -z "$SKILL_DESC" ]; then
    SKILL_DESC="Instructions for $SKILL_NAME."
fi

# 3. Create Title Case for Title
SKILL_TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

# 4. Copy template
echo "Creating skill '$SKILL_NAME' from template..."
mkdir -p "$TARGET_SKILL_DIR"
cp -R "$TEMPLATES_DIR/default-skill/." "$TARGET_SKILL_DIR/"

# 5. Replace placeholders in SKILL.md
# We use a temp file or python/sed to do drop-in replacement safely.
# On macOS, sed -i requires an extension parameter, so we use python or perl if available, or portable sed syntax.
# Let's use perl as it is standard on macOS and handles multi-line / simple replacements easily without sed platform issues.
perl -pi -e "s/\{\{SKILL_NAME\}\}/$SKILL_NAME/g" "$TARGET_SKILL_DIR/SKILL.md"
perl -pi -e "s/\{\{SKILL_DESCRIPTION\}\}/$SKILL_DESC/g" "$TARGET_SKILL_DIR/SKILL.md"
perl -pi -e "s/\{\{SKILL_TITLE\}\}/$SKILL_TITLE/g" "$TARGET_SKILL_DIR/SKILL.md"

echo "Success! Skill '$SKILL_NAME' created at: $TARGET_SKILL_DIR"
echo "You can view/edit it: $TARGET_SKILL_DIR/SKILL.md"
echo "To link it to the agent config run:"
echo "  just link $SKILL_NAME"
