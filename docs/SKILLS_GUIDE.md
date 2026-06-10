# AI Agent Skills Developer Guide

This guide describes how to design, organize, validate, and manage custom AI agent skills. By centralizing your skills in `/Users/amitkairon/aiskills` and symlinking them to the agent's config folder, you ensure that updates are immediately available across all instances.

---

## 1. Anatomy of a Skill Directory

A skill is a self-contained directory that instructs AI agents on how to execute complex or specialized workflows. The structure of a standard skill looks like this:

```
skills/my-custom-skill/
├── SKILL.md                 # REQUIRED: Main instruction file with YAML frontmatter
├── scripts/                 # OPTIONAL: Executable scripts that the agent runs to automate tasks
│   └── helper.sh
├── examples/                # OPTIONAL: Reference code, configurations, or outputs
│   └── config.example.json
├── resources/               # OPTIONAL: Images, video assets, screenshots, or templates
│   └── target_layout.png
└── references/              # OPTIONAL: Sub-documentation files linked from SKILL.md
    └── troubleshooting_db.md
```

---

## 2. The `SKILL.md` File

`SKILL.md` is the primary entrypoint that the AI agent reads to understand what the skill is, when to trigger it, and how to execute it.

### 2.1 YAML Frontmatter (Metadata Block)

Every `SKILL.md` **must** begin with a YAML frontmatter block enclosed by triple-dashes (`---`). The frontmatter defines key metadata used by the agentic orchestrator:

```yaml
---
name: my-custom-skill
description: Explains how to trigger and run my custom task. Triggers on custom keywords, setup requests, or specific file extensions.
---
```

#### Parameters:
*   **`name`**: (String, Required) The identifier for the skill.
    *   *Constraint 1*: Must be in lowercase, kebab-case (letters, numbers, and dashes only).
    *   *Constraint 2*: **Must match the directory name** exactly.
*   **`description`**: (String, Required) A clear, action-oriented explanation of what the skill does. The orchestrator uses this text to match user requests to skills. Include specific keywords, file names, or command prefixes that should activate this skill.

### 2.2 Standard Layout sections

After the frontmatter, write the instruction manual using standard Markdown:

1.  **Header (`# Title`)**: Human-readable name of the skill.
2.  **Overview**: High-level context of why the skill exists.
3.  **Trigger Conditions**: Clear definitions of what files, keywords, or setups should activate this skill.
4.  **Prerequisites & Dependencies**: Tools, environment variables, or API keys needed.
5.  **Step-by-Step Execution Guide**: Explicit instructions for the agent. Use numbered lists. Be precise and detail-oriented.
6.  **Common Pitfalls & Troubleshooting**: A table mapping error patterns to resolution instructions.

---

## 3. Directory Purposes & Best Practices

To make skills robust and maintainable, modularize content instead of dumping everything into a single file:

### 3.1 `scripts/` (Executable Automation)
*   **Purpose**: Scripts (Bash, Python, Node.js) that execute command-line tasks, generate assets, or validate settings.
*   **Usage**: The agent has full terminal capabilities and can run scripts here directly via the shell (e.g. `./scripts/helper.sh`).
*   **Tip**: Use standard arguments and exit codes. Document script usage in `SKILL.md`.

### 3.2 `examples/` (Reference Patterns)
*   **Purpose**: Code blocks, config files, or mock project structures showing *correct* implementation.
*   **Usage**: Point the agent to these files (e.g. `[example config](examples/config.example.json)`) so it has a reference template to copy or adapt.

### 3.3 `resources/` (Screenshots, Videos, & Media Assets)
*   **Purpose**: Visual assets, templates, overlays, mockup silhouettes, or guides.
*   **Usage**:
    *   **Screenshots**: Put visual design references or example outcomes in `resources/`. Embed them directly in markdown:
        `![Target Design](/Users/amitkairon/aiskills/skills/my-skill/resources/layout_spec.png)`
    *   **Videos**: Store reference screen recordings of correct UI behavior. Refer to them so the agent knows how elements animate or respond.
    *   **Templates**: If the skill scaffolds a project, store the source files in a `template/` or `resources/template/` subfolder.

### 3.4 `references/` (Modular Sub-documentation)
*   **Purpose**: Detailed sub-topics, API specs, database schemas, or platform-specific configs.
*   **Usage**: Keeps the main `SKILL.md` lightweight. If the agent needs to debug a database or handle iOS-specific errors, link it:
    `For details on debugging connection issues, see [database troubleshooting](references/troubleshooting_db.md).`

---

## 4. Symlinking Mechanism

AI agents look for active skills in the central directory `/Users/amitkairon/.gemini/config/skills/`.
By linking your skills from the repository, any updates you make inside `/Users/amitkairon/aiskills/skills/` are instantly updated for all agents.

### Creating the Link
A symlink is a filesystem pointer. It is created using:
```bash
ln -snf "/Users/amitkairon/aiskills/skills/my-skill" "/Users/amitkairon/.gemini/config/skills/my-skill"
```
*   `-s`: Creates a symbolic link instead of a hard link.
*   `-n`: Treats the target directory symlink as a file if it already exists, avoiding nesting the symlink inside the folder.
*   `-f`: Overwrites any existing symlink at that path.

---

## 5. Command Runner (`justfile`) Reference

A `justfile` is provided at the repository root to automate daily workflows:

| Command | Description | Example |
|:---|:---|:---|
| `just list` | Lists all skills and checks if they are active/symlinked | `just list` |
| `just create <name>` | Interactively scaffolds a new skill folder from the template | `just create web-scraper` |
| `just link <name>` | Symlinks the specified skill to the agent's config folder | `just link web-scraper` |
| `just unlink <name>` | Removes the symlink from the config folder | `just unlink web-scraper` |
| `just validate <name>` | Validates YAML metadata, checks placeholders, and verifies file links | `just validate web-scraper` |
| `just validate-all` | Validates all skills in the repository | `just validate-all` |

---

## 6. Writing High-Quality Skills (Instruction Design)

When writing instructions for AI agents, follow these principles to achieve reliable, correct results:

1.  **Avoid Placeholder Instructions**: Do not write "Write code here." Give the exact logic structure or reference implementation.
2.  **Define Checklists & Quality Bars**: Specify exactly what files must be modified, what tests must be run, and what output is expected.
3.  **Probing First**: Always instruct the agent to inspect the workspace first before making changes. E.g., "Look for package.json to identify the package manager."
4.  **Table-Based Troubleshooting**: Provide clear error patterns and remediation steps. Agents are excellent at matching console outputs to table rows.
5.  **Define Hand-off Behavior**: Specify how the agent should conclude the task (e.g., "Start the dev server and output the localhost URL to the user").
