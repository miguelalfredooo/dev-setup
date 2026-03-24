# dev-setup — Development Guide

## What This Project Does

Reusable environment initialization and template system for consistent development setup across all machines and projects. Contains shared environment variable templates, setup scripts, and best practices for managing secrets locally while keeping templates in git.

## Tech Stack

Bash scripting, environment variable templating, git best practices.

## How to Run Locally

**Initial setup:**
```bash
bash ~/Code/dev-setup/setup-env.sh
```

This:
1. Creates `~/.env.global` from `env.global.template`
2. Adds sourcing to `~/.zshrc`
3. Reloads shell

Then edit `~/.env.global` with your actual API keys.

**Per-project setup:**
```bash
cd /path/to/project
# Option 1: Symlink (recommended)
ln -s ~/Code/dev-setup/.env.development .env.local

# Option 2: Copy template
cp ~/Code/dev-setup/.env.development .env.local
# Edit as needed
```

## Folder Structure

```
setup-env.sh              # Main initialization script
env.global.template       # Global env variables (all projects)
.env.development          # Development environment template
.env.staging              # Staging environment template
README.md                 # Setup documentation
```

## Key Architectural Decisions

- **Three-tier hierarchy:** Global → Project-specific → Local overrides
- **Templates in git:** .env.* templates tracked for consistency
- **Secrets gitignored:** .env, .env.local, .env.production never committed
- **Machine-specific:** .env.local for per-workstation customization
- **git-secrets integration:** Prevents accidental secret commits

## Connections to Other Projects

**→ All projects:** Provides env templates and setup script
**Consumed by:** nooooowhere-club, design-tools, alfredo-studio, miguel-playground

**Shared:** ~/.env.global (master secret list)

## What NOT to Change Without Asking

- `.env.global` structure/variable names (used by all projects)
- `setup-env.sh` shell integration (affects ~/.zshrc globally)
- Permission model (600 on ~/.env.global — security critical)
- Variable naming conventions (affects all projects)

## Common Commands

```bash
bash ~/Code/dev-setup/setup-env.sh    # Initial setup
source ~/.env.global                  # Manual reload
chmod 600 ~/.env.global               # Fix permissions
cat env.global.template               # View all expected variables
```

## Adding New Global Variables

1. Add to `env.global.template` with description:
   ```bash
   # New service API key
   MY_SERVICE_API_KEY=your-key-here
   ```
2. Update all project `.env.template` files to include the new variable
3. Run `/sync-env --fix` across projects to update templates

**GitHub:** https://github.com/miguelalfredooo/dev-setup
