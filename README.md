# dev-setup

Reusable environment setup scripts and templates for development across all machines and accounts.

## Quick Start

```bash
bash ~/Code/dev-setup/setup-env.sh
```

This will:
1. Copy `env.global.template` to `~/.env.global` (if not already present)
2. Add global environment sourcing to `~/.zshrc`
3. Reload your shell

Then edit `~/.env.global` and add your actual API keys.

## Files

### Templates (tracked in git)
- **`env.global.template`** — Global environment variables (used by all projects)
- **`.env.development`** — Development environment (local services, mock data)
- **`.env.staging`** — Staging environment (staging services, real data)

### Protected (ignored by git)
- **`.env`** — Local overrides (any project)
- **`.env.local`** — Local overrides (any project)
- **`.env.production`** — Production secrets (never committed)
- **`*.secret`** — Any secret files

### Setup
- **`setup-env.sh`** — Initialization script

## Environment Hierarchy

1. **Global** (`~/.env.global`) — Shared across all projects
2. **Project-specific** (`.env.development`, `.env.staging`)
3. **Local overrides** (`.env.local`) — Machine-specific, not committed

## Usage Per Project

### Option 1: Symlink (recommended)
```bash
cd /path/to/project
ln -s ~/Code/dev-setup/.env.development .env.local
# Edit as needed for your machine
```

### Option 2: Copy template
```bash
cd /path/to/project
cp ~/Code/dev-setup/.env.development .env.local
# Edit with your values
```

### Option 3: Manual setup
Copy values from `~/.env.global` into your `.env.local`.

## Security

- ✅ Templates are tracked in git for consistency
- ✅ Actual secrets (`.env`, `.env.local`, `.env.production`) are gitignored
- ✅ `.env.global` is always 600 permissions (owner read/write only)
- ✅ Use `git-secrets` to prevent accidental commits

## On a New Machine

1. Clone this repo (or just run setup-env.sh if already cloned)
2. Run `bash ~/Code/dev-setup/setup-env.sh`
3. Edit `~/.env.global` with your API keys
4. For each project, use a `.env.local` for machine-specific overrides

## Notes

- `CLAUDE_MODEL` defaults to haiku (fast/cheap) — override in `.env.local` for specific projects
- Local services default to `localhost` — change in `.env.local` if needed
- `.env.development` has auth disabled (`NEXT_PUBLIC_AUTH_REQUIRED=false`) for easier testing
- `.env.staging` matches production setup (auth required, real services)
