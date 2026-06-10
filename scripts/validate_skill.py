#!/usr/bin/env python3

import os
import sys
import re

def print_err(msg):
    print(f"\033[91mError:\033[0m {msg}", file=sys.stderr)

def print_warn(msg):
    print(f"\033[93mWarning:\033[0m {msg}")

def print_ok(msg):
    print(f"\033[92mOK:\033[0m {msg}")

def validate_skill(skill_path):
    skill_name = os.path.basename(skill_path.rstrip("/"))
    skill_file = os.path.join(skill_path, "SKILL.md")

    if not os.path.exists(skill_file):
        print_err(f"SKILL.md not found in {skill_path}")
        return False

    with open(skill_file, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Frontmatter Validation
    frontmatter_match = re.match(r"^---\s*\n(.*?)\n---\s*\n", content, re.DOTALL)
    if not frontmatter_match:
        print_err("SKILL.md must start with a valid YAML frontmatter block enclosed in triple-dashes (---)")
        return False

    frontmatter_content = frontmatter_match.group(1)
    
    # Simple YAML key-value parser for frontmatter
    metadata = {}
    for line in frontmatter_content.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            key, val = line.split(":", 1)
            metadata[key.strip()] = val.strip().strip("'\"")

    # Check required keys
    errors = 0
    if "name" not in metadata:
        print_err("Frontmatter missing required field: 'name'")
        errors += 1
    else:
        name_val = metadata["name"]
        # Check name naming convention (kebab-case)
        if not re.match(r"^[a-z0-9-]+$", name_val):
            print_err(f"Skill name '{name_val}' must be lowercase alphanumeric and dashes only (kebab-case)")
            errors += 1
        if name_val != skill_name:
            print_err(f"Skill name in frontmatter ('{name_val}') must match the folder name ('{skill_name}')")
            errors += 1

    if "description" not in metadata:
        print_err("Frontmatter missing required field: 'description'")
        errors += 1
    elif not metadata["description"]:
        print_err("Frontmatter 'description' field is empty")
        errors += 1

    # 2. Check for leftover placeholders
    placeholders = re.findall(r"\{\{[A-Za-z0-9_]+\}\}", content)
    if placeholders:
        for placeholder in set(placeholders):
            print_warn(f"Placeholder '{placeholder}' was found in the document")

    # 3. Check markdown links to references and resources
    # Matches markdown links [text](path) and images ![text](path)
    links = re.findall(r"!?\[[^\]]*\]\(([^)]+)\)", content)
    for link in links:
        # Ignore external HTTP links or system absolute file links
        if link.startswith(("http://", "https://", "file://", "mailto:", "#")):
            continue
        
        # Check for relative file links
        link_clean = link.split("#")[0] # remove anchor links
        if not link_clean:
            continue
        
        # Check if the target is within the skill folder
        target_path = os.path.abspath(os.path.join(skill_path, link_clean))
        if not target_path.startswith(os.path.abspath(skill_path)):
            print_warn(f"Link '{link}' points outside the skill directory. This might break when symlinked.")
            continue
            
        if not os.path.exists(target_path):
            print_err(f"Linked file '{link_clean}' does not exist on disk at {target_path}")
            errors += 1

    if errors > 0:
        print_err(f"Validation failed for skill '{skill_name}' with {errors} error(s).")
        return False
    else:
        print_ok(f"Skill '{skill_name}' is valid!")
        return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: validate_skill.py <path_to_skill_directory>")
        sys.exit(1)
        
    path = sys.argv[1]
    if not os.path.isdir(path):
        print_err(f"Path '{path}' is not a directory.")
        sys.exit(1)
        
    success = validate_skill(path)
    sys.exit(0 if success else 1)
