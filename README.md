# 🤖 AI Agent Skills Repository

> A centralized source-of-truth workspace to develop, validate, and symlink custom skills for agentic AI architectures (such as Google Antigravity).

This repository solves a common developer pain point in agentic workflows: **local skill fragmentation**. Instead of duplicating instruction manuals, automations, and reference media across multiple workspaces, this repository allows you to edit them in a single place. AI agents access them via symbolic links, meaning any update propagates to all agent instances instantly.

---

## 🌟 Key Features

*   **⚡ Symlinking Engine**: Standardized CLI commands to instantly link and unlink skills to your agent's config folder.
*   **🛠️ CLI Automation (`justfile`)**: Commands to create, link, list, and validate skills without manual path editing.
*   **🔍 Python-based Validation**: An integrated linter checking YAML frontmatter, naming conventions, outstanding template placeholders, and broken file path references.
*   **📂 Modular Directory Architecture**: Structured directories for executable scripts (`scripts/`), reference code (`examples/`), media guides (`resources/`), and modular sub-documentation (`references/`).
*   **🧩 Compliant Templates**: Standard blueprints to bootstrap clean, parseable skills in seconds.

---

## 📁 Repository Structure

```
.
├── .templates/             # Blueprint templates for bootstrapping new skills
│   └── default-skill/
│       ├── SKILL.md        # Required YAML frontmatter and instruction skeleton
│       ├── scripts/        # Skill automation scripts
│       ├── examples/       # Reference code configurations
│       ├── resources/      # Screenshots, videos, and visual design files
│       └── references/     # Detailed sub-documentation
├── docs/
│   └── SKILLS_GUIDE.md     # Detailed developer guide on writing effective skills
├── justfile                # Command runner configuration
├── scripts/                # Backend shell & python automation scripts
└── skills/                 # Target folder where your custom skills live
```

---

## 🚀 Getting Started

### Prerequisites
Make sure you have [just](https://github.com/casey/just) and `python3` installed on your machine:
```bash
brew install just
```

### 1. Initialize a New Skill
Create a new skill from the default template:
```bash
just create <skill-name> "<short description>"
```
This scaffolds a standard folder layout under `skills/<skill-name>`.

### 2. Validate the Skill
Before deploying your skill, run the Python-based linter to verify that the YAML frontmatter is correctly formatted, placeholders are resolved, and markdown links are valid:
```bash
just validate <skill-name>
# Or validate all skills in the repo:
just validate-all
```

### 3. Deploy/Symlink to Agent Config
To make the skill active and discoverable by local AI agents, link it:
```bash
just link <skill-name>
```
This symlinks your skill to the default agent directory (`~/.gemini/config/skills/`).

### 4. Check Status
List all skills inside the repository and view their current symlink connection status:
```bash
just list
```

### 5. Remove Symlink
To safely remove the symlink without touching the source code:
```bash
just unlink <skill-name>
```

---

## 📝 Writing High-Quality Skills

For detailed rules on how to write effective agent prompts, incorporate media files (like screenshots and videos), structure parameters, and write robust troubleshooting matrices, refer to the [docs/SKILLS_GUIDE.md](docs/SKILLS_GUIDE.md).

---

## 🤝 Open Source & Contributions

This repository is built with open-source principles in mind. If you have created robust skills for app building, code styling, design auditing, or visual testing:
1. Fork the repo.
2. Add your skill under `skills/` (ensuring it passes `just validate`).
3. Open a Pull Request!

*Let's build a rich, community-driven database of expert AI agent capabilities.*
