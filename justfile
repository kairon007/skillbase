# Justfile for AI Agent Skills Repository
# Run 'just' without arguments to see available recipes.

set shell := ["bash", "-uc"]

default:
    @just --list

# Create a new skill from the default template
create name="" desc="":
    @./scripts/create_skill.sh "{{name}}" "{{desc}}"

# Validate a specific skill's structure and YAML metadata
validate name:
    @./scripts/validate_skill.sh "{{name}}"

# Validate all skills in the repository
validate-all:
    @echo "Validating all skills..."
    @failed=0; \
    for skill in $(ls -1 skills/ 2>/dev/null || true); do \
        if ! ./scripts/validate_skill.sh "$skill"; then \
            failed=$((failed + 1)); \
        fi; \
        echo "----------------------------------------"; \
    done; \
    if [ "$failed" -gt 0 ]; then \
        echo "Validation failed: $failed skill(s) had errors." >&2; \
        exit 1; \
    fi; \
    echo "All skills are valid!"

# Symlink a skill to the global agent config path
link name target="":
    @./scripts/link_skill.sh "{{name}}" "{{target}}"

# Remove the symlink for a skill
unlink name target="":
    @./scripts/unlink_skill.sh "{{name}}" "{{target}}"

# List all skills in the repository and show their link status
list target_dir="/Users/amitkairon/.gemini/config/skills":
    @echo "=========================================================="
    @echo "  AI AGENT SKILLS REPOSITORY"
    @echo "=========================================================="
    @echo "Skill Name               Status     Symlink Location"
    @echo "----------------------------------------------------------"
    @found=0; \
    for skill in $(ls -1 skills/ 2>/dev/null || true); do \
        found=1; \
        link_path="{{target_dir}}/$skill"; \
        if [ -L "$link_path" ]; then \
            dest=$(readlink "$link_path"); \
            printf "%-24s \033[92m%-10s\033[0m %s\n" "$skill" "Linked" "-> $dest"; \
        elif [ -e "$link_path" ]; then \
            printf "%-24s \033[93m%-10s\033[0m %s\n" "$skill" "Blocked" "(File exists but is not symlink!)"; \
        else \
            printf "%-24s \033[90m%-10s\033[0m %s\n" "$skill" "Unlinked" "-"; \
        fi; \
    done; \
    if [ "$found" -eq 0 ]; then \
        echo "No skills found in skills/ directory. Create one with 'just create'."; \
    fi; \
    echo "=========================================================="
