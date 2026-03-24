# Work-Safe Setup Guide

For machines with existing work projects (e.g., realmeal-app connected to Vercel).
This variant skips global git config and gitignore that could break work repos.

---

## What This Skips (vs BOOTSTRAP.md)

❌ **DO NOT RUN:**
- `git config --global user.name` (would change work commits)
- `git config --global user.email` (would use wrong account)
- `git config --global core.excludesfile ~/.gitignore_global` (hides work files)
- `git secrets --install --global` (could block work commits)

✅ **SAFE TO RUN:**
- `setup-env.sh` (creates ~/.env.global only)
- Per-repo CLAUDE.md files
- Per-repo .env.local
- Project-specific git config (local, not global)

---

## Step-by-Step (Work-Safe)

### Step 1: Back up work git config

```bash
git config --global --list > ~/work-git-config-backup.txt
echo "✅ Backed up git config to ~/work-git-config-backup.txt"
```

### Step 2: Run setup-env.sh (safe part only)

```bash
cd ~/Code/dev-setup
bash setup-env.sh
```

This creates:
- `~/.env.global` ✅ Safe (just sourced, doesn't affect work repos)
- `~/Code/PROJECTS.md` ✅ Safe (reference file)
- Adds to `~/.zshrc` ✅ Safe (only sources env vars)

### Step 3: Populate ~/.env.global

```bash
nano ~/.env.global
# Add your personal API keys (keep separate from work keys)
```

**Important:** If work repo uses same keys, duplicate them in project `.env.local`:
```bash
cd ~/Code/realmeal-app
cp .env.template .env.local
# Add: ANTHROPIC_API_KEY=<work-key>, SUPABASE_SERVICE_ROLE_KEY=<work-key>, etc.
```

### Step 4: Set git config PER REPO (not globally)

For personal projects:
```bash
cd ~/Code/alfredo-studio
git config user.name "Your Personal Name"
git config user.email "personal@email.com"
```

For work projects (keep as-is):
```bash
cd ~/Code/realmeal-app
# DON'T CHANGE - check it's correct:
git config user.name
git config user.email
# Should show developer's original name/email
```

### Step 5: Verify work repo is untouched

```bash
cd ~/Code/realmeal-app

# Check author config
git config user.name
git config user.email

# Check remote (should still point to Vercel)
git remote -v
# Should show: origin -> ...github.com/cafemedia/realmeal-app (or similar)

# Verify no accidental commits
git log -1 --format="%an <%ae>"
# Should match work developer's name/email
```

### Step 6: Clone personal projects

```bash
cd ~/Code

# Personal projects (can use ~/.env.global freely)
git clone https://github.com/miguelalfredooo/nooooowhere-club.git
git clone https://github.com/miguelalfredooo/design-tools.git
git clone https://github.com/miguelalfredooo/alfredo-studio.git

# For each, set local git config
cd nooooowhere-club
git config user.name "Your Name"
git config user.email "your@email.com"

cd ../design-tools
git config user.name "Your Name"
git config user.email "your@email.com"

cd ../alfredo-studio
git config user.name "Your Name"
git config user.email "your@email.com"
```

---

## Environment Variable Strategy

### Machine with Mixed Repos

```
~/.env.global (personal API keys)
├── ANTHROPIC_API_KEY=sk-ant-personal-...
├── SUPABASE_SERVICE_ROLE_KEY=sbpvt_personal-...
└── OLLAMA_BASE_URL=http://localhost:11434

~/Code/realmeal-app/.env.local (work keys, overrides global)
├── ANTHROPIC_API_KEY=sk-ant-work-...  ← This takes priority
├── SUPABASE_SERVICE_ROLE_KEY=sbpvt_work-...
└── NEXT_PUBLIC_SUPABASE_URL=https://work.supabase.co

~/Code/nooooowhere-club/.env.local (empty or personal overrides)
└── (inherits from ~/.env.global)
```

**How it works:**
1. Shell sources `~/.env.global` (personal keys)
2. Projects load `.env.local` (if exists, overrides global)
3. work-app gets work keys, personal projects get personal keys

---

## Per-Repo Setup (Realmeal-App)

Keep realmeal-app exactly as developer set it up:

```bash
cd ~/Code/realmeal-app

# ✅ Keep existing .env.local as-is
# ✅ Keep existing git remotes as-is
# ✅ Keep existing git user.name/user.email (local config)
# ✅ Don't run any global git-secrets setup

# Just verify it still works
npm run dev  # Should still deploy to Vercel on push
git log -1   # Should show correct author
```

---

## Git Workflow (Work-Safe)

### Before starting work in ANY repo

```bash
cd ~/Code/[repo]

# 1. Check which account/user this repo uses
git config user.name
git config user.email

# 2. For work repo: NEVER change these
# 3. For personal repos: OK if you set them

# 4. Verify remotes
git remote -v

# 5. For work repo: should point to work GitHub
# 6. For personal: can point to miguelalfredooo or migsraptive
```

### Safe git workflow

```bash
# Personal repo (OK to do anything)
cd ~/Code/alfredo-studio
git checkout -b feat/my-feature
# ... work ...
git push origin feat/my-feature

# Work repo (be careful!)
cd ~/Code/realmeal-app
git checkout -b feat/work-thing
# ... work ...
git push origin feat/work-thing  # Goes to Vercel, uses work account
```

---

## What NOT to Do

🚫 **DO NOT:**
- Run `git config --global user.name` (changes all repos globally)
- Run `git config --global core.excludesfile ~/.gitignore_global` (hides work files)
- Run `git secrets --install --global` (blocks work commits if configured wrong)
- Run `gh auth switch` on work computer (changes default GitHub account)
- Use personal ~/.env.global keys in work repo `.env.local`
- Commit work keys to git (ever!)

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Work commits show wrong author | `cd ~/Code/realmeal-app && git config user.name "correct-name"` |
| Vercel deploy fails after setup | Check `git remote -v` still points to work repo |
| `.env.local` has wrong keys | Reset: `rm .env.local && cp .env.template .env.local` then add work keys |
| Personal projects can't find API keys | Check `~/.env.global` is populated and sourced: `echo $ANTHROPIC_API_KEY` |
| git-secrets is blocking work commits | You didn't install it globally (good!) Just make normal commits |

---

## File Structure (Work-Safe)

```
~/.env.global                    # Personal keys only

~/Code/
├── dev-setup/                   # This repo
├── PROJECTS.md                  # Reference (safe)
├── realmeal-app/                # Work repo (UNTOUCHED)
│   ├── .env.local              # Work keys (never committed)
│   └── [developer's structure]
├── alfredo-studio/              # Personal
│   ├── .env.local              # Uses ~/.env.global
│   ├── .git/config             # user.name/email set locally
│   └── [standard structure]
└── [other personal projects]/
    ├── .env.local
    └── .git/config
```

---

## Verification Checklist

Before committing to realmeal-app after setup:

- [ ] `cd ~/Code/realmeal-app`
- [ ] `git config user.name` → shows developer name (not yours)
- [ ] `git config user.email` → shows work email
- [ ] `git remote -v` → shows work GitHub (not miguelalfredooo)
- [ ] `git log -1 --format="%an <%ae>"` → shows work developer
- [ ] `echo $ANTHROPIC_API_KEY` → shows key value (not empty)
- [ ] `npm run dev` → starts without errors
- [ ] Make small change, `git add .`, `git commit -m "test"` → succeeds
- [ ] `git push origin [branch]` → pushes to work repo

**All pass?** You're safe. Setup didn't break realmeal-app.

---

## Summary

✅ **Safe to do:**
- Use ~/.env.global for personal API keys
- Clone personal projects alongside realmeal-app
- Use BOOTSTRAP.md for personal machines
- Set git config per-repo (local, not global)

✅ **Won't affect realmeal-app:**
- ~/.env.global (just sources env vars)
- PROJECTS.md (reference file)
- Per-repo CLAUDE.md files
- Per-repo .env.local (overrides global anyway)

❌ **Don't do:**
- Global git config (could break work commits)
- Global .gitignore (could hide work files)
- Change GitHub account (could push to wrong place)
- Global git-secrets (could block work commits)

**Result:** Both personal and work projects coexist safely on same machine.

---

Generated: 2026-03-23
Version: 1.0
