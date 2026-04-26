---
name: "skill-creator"
description: "Provides guidance for creating effective custom Skills for the workspace. Invoke when user wants to create a new skill, add a custom skill, set up a skill template, or asks how to create a skill."
---

# Skill Creator

This skill provides guidance for creating effective skills.

## About Skills

Skills are modular, self-contained packages that extend Claude's capabilities by providing specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific domains or tasks—they transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

- **Specialized workflows** - Multi-step procedures for specific domains
- **Tool integrations** - Instructions for working with specific file formats or APIs
- **Domain expertise** - Company-specific knowledge, schemas, business logic
- **Bundled resources** - Scripts, references, and assets for complex and repetitive tasks

## Core Principles

### Concise is Key

The context window is a public good. Skills share the context window with everything else Claude needs: system prompt, conversation history, other Skills' metadata, and the actual user request.

- Default assumption: Claude is already very smart. Only add context Claude doesn't already have.
- Challenge each piece of information: "Does Claude really need this explanation?" and "Does this paragraph justify its token cost?"
- Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

Match the level of specificity to the task's fragility and variability:

- **High freedom** (text-based instructions): Use when multiple approaches are valid, decisions depend on context, or heuristics guide the approach.
- **Medium freedom** (pseudocode or scripts with parameters): Use when a preferred pattern exists, some variation is acceptable, or configuration affects behavior.
- **Low freedom** (specific scripts, few parameters): Use when operations are fragile and error-prone, consistency is critical, or a specific sequence must be followed.

Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).

## Anatomy of a Skill

Every skill consists of a required `SKILL.md` file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation intended to be loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

### SKILL.md (required)

Every SKILL.md consists of:

**Frontmatter (YAML):** Contains `name` and `description` fields. These are the only fields that Claude reads to determine when the skill gets used, thus it is very important to be clear and comprehensive in describing what the skill is, and when it should be used.

**Body (Markdown):** Instructions and guidance for using the skill. Only loaded AFTER the skill triggers (if at all).

### Bundled Resources (optional)

#### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include:** When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example:** `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits:** Token efficient, deterministic, may be executed without loading into context
- **Note:** Scripts may still need to be read by Claude for patching or environment-specific adjustments

#### References (`references/`)

Documentation and reference material intended to be loaded as needed into context to inform Claude's process and thinking.

- **When to include:** For documentation that Claude should reference while working
- **Examples:** `references/finance.md` for financial schemas, `references/mnda.md` for company NDA template, `references/policies.md` for company policies, `references/api_docs.md` for API specifications
- **Use cases:** Database schemas, API documentation, domain knowledge, company policies, detailed workflow guides
- **Benefits:** Keeps SKILL.md lean, loaded only when Claude determines it's needed
- **Best practice:** If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication:** Information should live in either SKILL.md or references files, not both. Prefer references files for detailed information unless it's truly core to the skill—this keeps SKILL.md lean while making information discoverable without hogging the context window. Keep only essential procedural instructions and workflow guidance in SKILL.md; move detailed reference material, schemas, and examples to references files.

#### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output Claude produces.

- **When to include:** When the skill needs files that will be used in the final output
- **Examples:** `assets/logo.png` for brand assets, `assets/slides.pptx` for PowerPoint templates, `assets/frontend-template/` for HTML/React boilerplate, `assets/font.ttf` for typography
- **Use cases:** Templates, images, icons, boilerplate code, fonts, sample documents that get copied/modified

## Skill Creation Workflow

When user asks to create a skill:

1. **Determine skill name** - Ask user or infer from context
2. **Write description** - Must include:
   - What the skill does (functionality)
   - When to invoke it (trigger conditions/scenarios)
   - Example format: "Does X. Invoke when Y happens or user asks for Z."
   - Use English by default unless user specifies another language
   - Keep under 200 characters
3. **Create directory** - `.trae/skills/<skill-name>/`
4. **Write SKILL.md** - Proper YAML frontmatter + markdown body
5. **Add optional resources** - scripts/, references/, assets/ as needed
6. **Validate structure** - Ensure name matches directory, description is comprehensive

## SKILL.md Template

```markdown
---
name: "<skill-name>"
description: "<what it does>. Invoke when <trigger conditions>."
---

# <Skill Title>

## Purpose
<Brief explanation of what this skill enables>

## When to Use
<Specific scenarios where this skill should be invoked>

## Guidelines
<Step-by-step instructions or heuristics>

## Examples
<Concise examples showing the skill in action>

## Resources
<Reference to any bundled scripts, references, or assets>
```

## Important Notes

- **Language:** Use English for name and description fields unless user explicitly requests another language. The body can be in the user's preferred language.
- **Description critical:** The description field is the ONLY thing Claude reads to decide whether to invoke a skill. It must be clear, comprehensive, and accurate.
- **Keep SKILL.md lean:** Move detailed content to references/ files. Only keep essential instructions in SKILL.md.
- **No duplication:** Don't repeat the same information in SKILL.md and references files.
