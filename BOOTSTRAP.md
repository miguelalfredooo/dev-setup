# Bootstrap Guide — Complete Environment Setup

A runbook for replicating the professional development environment from scratch on any machine.

---

## The Problem We Solved

### Before
- API keys scattered across multiple `.env` files with no consistency
- Each project managed secrets independently (no master list)
- Switching machines required manual setup of 5+ config files
- No cross-project context (developers didn't know which projects existed or how they related)
- No standardized Claude Code setup across machines
- Git history vulnerable to accidental secret commits
- No documentation of architectural decisions

### After
- Single master secret source (`~/.env.global`) sourced by all projects
- Projects reference global variables, define only overrides locally
- Environment setup automated via `setup-env.sh` (2-3 minutes)
- Complete ecosystem documented in `PROJECTS.md` (Tier 1 + Tier 2 projects)
- Claude Code globally configured with reusable patterns and slash commands
- `git-secrets` prevents secret commits; `.gitignore_global` enforces protection
- Every project has a `CLAUDE.md` documenting architecture, setup, and constraints

---

## Setup Steps (In Order)

### Step 1: Clone dev-setup repo

```bash
cd ~/Code
git clone https://github.com/miguelalfredooo/dev-setup.git
cd dev-setup
```

### Step 2: Run setup-env.sh to bootstrap global environment

This script creates `~/.env.global`, adds sourcing to `~/.zshrc`, and copies `PROJECTS.md`:

```bash
bash ~/Code/dev-setup/setup-env.sh
```

**What it does:**
1. Creates `~/.env.global` from `env.global.template` (if not exists)
2. Sets permissions to 600 (owner read/write only)
3. Adds sourcing block to `~/.zshrc`: `set -a; source ~/.env.global; set +a`
4. Copies `PROJECTS.md` to `~/Code/PROJECTS.md`
5. Reloads shell configuration

**Output:**
```
🔧 Setting up environment...
📝 Copying env.global.template to ~/.env.global...
✅ Created ~/.env.global with mode 600
📝 Adding sourcing block to ~/.zshrc...
✅ Added sourcing block to ~/.zshrc
📝 Copying PROJECTS.md ecosystem map to ~/Code/...
✅ Created ~/Code/PROJECTS.md
🔄 Reloading ~/.zshrc...
✨ Environment setup complete!
```

### Step 3: Populate ~/.env.global with real API keys

**Never commit this file.** It's in `~/.gitignore_global` globally.

Open `~/.env.global` and fill in values from:
- Anthropic console (API keys)
- Supabase dashboards (service role keys)
- Local services (Ollama, crew APIs)

```bash
# Example ~/.env.global structure (values are placeholders)
ANTHROPIC_API_KEY=sk-ant-...
SUPABASE_SERVICE_ROLE_KEY=sbpvt_...
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
CARRIER_API_URL=http://localhost:5001
CREW_API_URL=http://localhost:8000
OLLAMA_BASE_URL=http://localhost:11434
NEXT_PUBLIC_AUTH_REQUIRED=false
CLAUDE_MODEL=claude-haiku-4-5-20251001
```

### Step 4: Configure git globally (one-time per machine)

```bash
# Set git user for commits
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Point git to global gitignore
git config --global core.excludesfile ~/.gitignore_global

# Install git-secrets to prevent accidental secret commits
brew install git-secrets

# Initialize git-secrets hooks globally
git secrets --install --global
git secrets --register-aws --global  # AWS pattern library

# Add custom patterns for our secrets
git secrets --add --global 'ANTHROPIC_API_KEY='
git secrets --add --global 'SUPABASE_SERVICE_ROLE_KEY='
git secrets --add --global 'sk-ant-'
git secrets --add --global 'sbpvt_'
```

### Step 5: Create ~/.gitignore_global

```bash
cat > ~/.gitignore_global << 'EOF'
# Environment files (never commit)
.env
.env.local
.env.*.local
.env.production
.env.production.local
.env.development.local
.env.staging.local

# Secrets
*.secret
*.key
*.pem

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Node
node_modules/
.next/
dist/
build/

# Python
.venv/
__pycache__/
*.pyc
.pytest_cache/

# Local
tmp/
temp/
*.log
EOF
```

### Step 6: Set up Claude Code globally (~/.claude/CLAUDE.md)

This file is your global instructions for all projects. See full content in `~/.claude/CLAUDE.md`.

**Key sections:**
- Before Starting Any Work (check for local patterns)
- Package Management Rules (npm, pip, brew)
- Current Stack (Node, Python versions)
- Project Layout (where projects live)
- Security Rules (API key management)
- Development Workflow (git, branching)
- Code Style (match existing patterns)
- Communication (ask before destructive operations)

### Step 7: Clone Tier 1 projects (core products)

```bash
cd ~/Code

# Web gallery
git clone https://github.com/miguelalfredooo/nooooowhere-club.git

# Mobile + crew
git clone https://github.com/miguelalfredooo/nooooowhere-club-rn.git

# Design tools (Carrier)
git clone https://github.com/miguelalfredooo/design-tools.git

# Portfolio
git clone https://github.com/miguelalfredooo/alfredo-studio.git
```

### Step 8: Set up per-project .env.local files

For each project, create `.env.local` from template:

```bash
# For each project
cd ~/Code/[project]
cp .env.template .env.local
# Edit .env.local for machine-specific overrides (optional)
# Most values come from ~/.env.global automatically
```

### Step 9: Install project dependencies

```bash
cd ~/Code/[project]
npm install

# For projects with crew/ (Python backend)
cd crew
python -m venv crew_venv
source crew_venv/bin/activate
pip install -r requirements.txt
```

### Step 10: Verify setup with /start command (optional)

Claude Code has a built-in pre-flight check:

```bash
cd ~/Code/[project]
# In Claude Code session:
/start --verbose
```

This validates:
- Git status and branch
- Environment variables
- Dependencies installed
- Database/API connectivity
- Project-specific checks

---

## Professional Dev Environment File Structure

This is what your machine looks like after setup:

```
~/.env.global                    # Master secrets (gitignored globally)
~/.zshrc                         # Contains: source ~/.env.global
~/.gitignore_global             # Global patterns (*.env*, *.secret, node_modules, .venv/)
~/.gitignore_core               # Git secrets config

~/.claude/
├── CLAUDE.md                    # Global instructions for all projects
├── commands/
│   ├── start.md                # /start pre-flight check
│   ├── audit.md                # /audit security review
│   ├── sync-env.md             # /sync-env template sync
│   ├── new-project.md          # /new-project scaffolding
│   ├── onboard.md              # /onboard documentation generator
│   └── [other skills].md
└── projects/                    # Project-specific memory
    └── [project-name]/memory.md

~/Code/
├── PROJECTS.md                 # Ecosystem map (Tier 1 + Tier 2)
├── dev-setup/                  # This repo
│   ├── setup-env.sh           # Bootstrap script
│   ├── BOOTSTRAP.md           # This file
│   ├── CLAUDE.md              # Infrastructure guide
│   ├── env.global.template    # Template for ~/.env.global
│   ├── .env.development       # Dev template
│   ├── .env.staging           # Staging template
│   └── PROJECTS.md            # Copy of ecosystem map
│
├── nooooowhere-club/          # Tier 1: Web gallery
│   ├── CLAUDE.md              # Project architecture
│   ├── .env.template          # Expected env vars
│   ├── .env.local             # Machine-specific (gitignored)
│   ├── .nvmrc                 # Node version
│   ├── package.json
│   ├── app/                   # Next.js App Router
│   └── lib/                   # Utilities
│
├── nooooowhere-club-rn/       # Tier 1: Mobile + crew
│   ├── CLAUDE.md
│   ├── .env.local
│   ├── .python-version        # Python version (≤3.13 for CrewAI)
│   ├── App.tsx
│   └── crew/                  # Python FastAPI backend
│       └── crew_venv/         # Python venv
│
├── design-tools/              # Tier 1: Carrier (design voting)
│   ├── CLAUDE.md
│   ├── .env.local
│   ├── .nvmrc
│   ├── .crew-python-version
│   ├── app/                   # Next.js frontend
│   ├── crew/                  # Python CrewAI backend
│   └── lib/
│
├── alfredo-studio/            # Tier 1: Creative portfolio
│   ├── CLAUDE.md
│   ├── .env.local
│   ├── .nvmrc
│   ├── app/                   # Next.js routes
│   └── public/demos/          # 37+ interactive sketches
│
├── design-tools-work/         # Tier 2: Experimental fork
│   └── CLAUDE.md
│
├── miguel-playground/         # Tier 2: Component testing
│   ├── CLAUDE.md
│   ├── .storybook/
│   └── .nvmrc
│
└── [other projects]/
    └── CLAUDE.md
```

---

## Rules Claude Always Follows

From `~/.claude/CLAUDE.md`:

### Before Starting Any Work
1. Check what's installed (`node --version`, `python3 --version`)
2. Look for existing patterns in ~/Code before creating new ones
3. Version pinning is mandatory (`.nvmrc`, `.python-version`)

### Package Management
| Tool | Usage | Rule |
|------|-------|------|
| **brew** | System packages, CLI tools | node, python, git, supabase, git-secrets |
| **npm** | Project dependencies | Always `npm install` locally, NEVER globally |
| **pip + venv** | Python packages | Always `.venv`, NEVER global pip |

### Code Style
- Match existing code in the file you're editing
- Never refactor outside the scope of current task
- Ask before changing shared utilities or types
- Don't add comments/docstrings to code you didn't change

### Git Workflow
- **Never work on main directly** — always create feature branch
- Branch naming: `feat/description`, `fix/description`, `chore/description`
- Auto-push every ~20 minutes (WIP safety)
- Create PR before merging to main
- Delete branch after merge (both remote and local)

### Communication
- Ask ONE clarifying question if task is ambiguous
- Flag if change affects other projects in ~/Code
- Warn before destructive operations (git rewrites, deletes, deployments)

---

## Security Rules (Never Violate)

### Secrets Management
1. **Never commit**: `.env`, `.env.local`, `.env.production`, `*.secret`
2. **Global .gitignore:** `~/.gitignore_global` protects all projects
3. **git-secrets hooks:** Prevent accidental secret commits (installed globally)
4. **API keys location:** `~/.env.global` only (never in `.env.template`)

### Key Rotation
- Rotate keys every 90 days minimum
- When key exposed: rotate immediately
- Use `/audit` to scan for exposed secrets
- Use BFG to remove keys from git history if needed

### git-secrets Workflow
```bash
# Secrets are checked on every commit
# If commit blocked by git-secrets:

# 1. Remove the secret from your code
git restore <file>

# 2. Or stash if you didn't mean to commit
git stash

# 3. Then commit again (without secrets)
```

### What Requires Secrets Scanning
- `.env*` files in any commit
- API keys (sk-ant-, sbpvt_, etc.)
- Database credentials
- OAuth tokens
- Database passwords

Run `/audit` monthly to check for exposed secrets:
```bash
/audit --scope all
```

---

## Onboarding a New Machine From Scratch

**Total time: ~15 minutes**

### Phase 1: Clone and Bootstrap (5 min)

```bash
# 1. Clone dev-setup
mkdir -p ~/Code
cd ~/Code
git clone https://github.com/miguelalfredooo/dev-setup.git
cd dev-setup

# 2. Run setup script
bash setup-env.sh

# 3. Fill in ~/.env.global with API keys
nano ~/.env.global
# Add: ANTHROPIC_API_KEY, SUPABASE_SERVICE_ROLE_KEY, etc.
```

### Phase 2: Git Configuration (3 min)

```bash
# Global git user
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# git-secrets (prevents secret commits)
brew install git-secrets
git secrets --install --global
git secrets --register-aws --global
git secrets --add --global 'sk-ant-'
git secrets --add --global 'sbpvt_'
```

### Phase 3: Clone Projects (3 min)

```bash
cd ~/Code

# Tier 1 projects
git clone https://github.com/miguelalfredooo/nooooowhere-club.git
git clone https://github.com/miguelalfredooo/nooooowhere-club-rn.git
git clone https://github.com/miguelalfredooo/design-tools.git
git clone https://github.com/miguelalfredooo/alfredo-studio.git

# Tier 2 (optional)
git clone https://github.com/migsraptive/miguel-playground.git
```

### Phase 4: Install Dependencies (4 min)

```bash
# alfredo-studio (3456)
cd ~/Code/alfredo-studio
npm install

# nooooowhere-club (3457)
cd ~/Code/nooooowhere-club
npm install

# design-tools (3500/8000)
cd ~/Code/design-tools
npm install
cd crew && python -m venv crew_venv
source crew_venv/bin/activate
pip install -r requirements.txt

# nooooowhere-club-rn (3458/5001)
cd ~/Code/nooooowhere-club-rn
npm install
cd crew && python -m venv crew_venv
source crew_venv/bin/activate
pip install -r requirements.txt
```

### Phase 5: Verify Setup (optional)

```bash
# Check one project
cd ~/Code/nooooowhere-club

# In Claude Code:
/start --verbose

# Should show:
# ✅ Project detected
# ✅ Git status clean
# ✅ Environment variables set
# ✅ Dependencies installed
# ✅ APIs connected
```

---

## Reading List for New Developer

**Essential:**
1. `~/Code/PROJECTS.md` — Ecosystem map, architecture, data flows
2. `~/.claude/CLAUDE.md` — Global development standards
3. `~/Code/[project]/CLAUDE.md` — Project-specific architecture

**Reference:**
- `~/Code/dev-setup/BOOTSTRAP.md` — This file
- `~/Code/dev-setup/setup-env.sh` — What the bootstrap does
- `.env.template` (each project) — Expected environment variables

**Tools:**
- `/start` — Pre-flight checks before work
- `/audit` — Security and dependency audit
- `/sync-env` — Validate .env templates
- `/new-project` — Scaffold new projects
- `/onboard` — Generate role-based guides

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `ANTHROPIC_API_KEY not found` | Run `setup-env.sh` again, fill `~/.env.global` |
| `Port already in use` | `lsof -i :3457` to find process, `kill -9 <pid>` |
| `Crew API not responding` | Activate venv: `source crew_venv/bin/activate`, restart |
| `Python version mismatch` | Check `.python-version`, install with `pyenv` |
| `node_modules stale` | Run `npm install` again |
| `git-secrets blocks commit` | Remove secret, run `git add <file>`, try again |
| `Can't push to GitHub` | Run `gh auth status`, switch account if needed |

---

## Version Reference

When setting up a new machine, use these pinned versions:

| Tool | Version | How to Install |
|------|---------|----------------|
| **Node** | 20.19.4 | `nvm install 20` (see `.nvmrc`) |
| **Python** | 3.14.3 (general), ≤3.13 (crew) | `pyenv install` (see `.python-version`) |
| **npm** | 10.8.2+ | Installed with Node |
| **git** | Latest | `brew install git` |
| **git-secrets** | Latest | `brew install git-secrets` |

---

## Summary

This bootstrap process creates a **professional, portable development environment** that:

✅ Centralizes secrets (never scattered across projects)
✅ Prevents accidental secret commits (git-secrets)
✅ Automates setup on new machines (setup-env.sh, 15 minutes)
✅ Documents architecture and patterns (CLAUDE.md per project)
✅ Maintains consistency across developers (global rules, templates)
✅ Enables rapid context switching (PROJECTS.md, ecosystem awareness)

**One machine, one script, ~15 minutes = full development environment ready to work.**

---

Generated: 2026-03-23
Version: 1.0
