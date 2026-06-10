---
name: {{SKILL_NAME}}
description: {{SKILL_DESCRIPTION}}
---

# {{SKILL_TITLE}}

## Overview
Describe the primary goal of this skill, what it accomplishes, and the contexts in which the agent should trigger it.

## Trigger Conditions
State when this skill must be triggered by the agent. E.g., when the user mentions certain keywords, file types, or commands.

## Prerequisites & Dependencies
List any requirements:
- CLIs or tools needed (e.g., `ffmpeg`, `docker`, `npm`)
- API keys, variables, or environment setup
- Required workspace paths or configuration files

## Folder Structure
Explain any local supporting assets in this skill:
- **`scripts/`**: Executable scripts (bash, python, node) for task automation.
- **`examples/`**: Code snippets, reference outputs, or mock setups.
- **`resources/`**: Design files, templates, media, screenshots, or videos.
- **`references/`**: Modular sub-documents containing specialized details to keep the main `SKILL.md` concise.

## Step-by-Step Execution Guide

### Step 1: Probe & Verify Environment
Instruct the agent how to verify the current setup (e.g. check for existing configs, files, or lockfiles) before proceeding.

### Step 2: Main Logic & Execution Flow
The primary step-by-step instructions for the agent to follow.
1. 
2. 
3. 

### Step 3: Configuration & Customization
Explain how the agent should adjust settings, parameters, presets, or parameters based on user instructions.

### Step 4: Verification & Hand-off
Outline the verification steps and the exact message formatting, port URLs, or instructions to output to the user upon success.

## Common Pitfalls & Troubleshooting
A lookup table showing common issues, how the agent can detect them, and how to recover.

| Mistake / Issue | How to Detect | Remediation / Fix |
|:---|:---|:---|
| e.g., Missing dependency | Tool output displays command not found | Ask user to install or offer install command |
| | | |
