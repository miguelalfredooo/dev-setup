# Projects Map — Complete Overview

Your core projects (Tier 1) and development/infrastructure projects (Tier 2).

---

## Tier 1: Core Products

| Project | Type | Port | Primary Use | Supabase DB | Deploys To | Status |
|---------|------|------|-------------|------------|-----------|--------|
| **nooooowhere-club** | Next.js gallery | 3457 | Web: invite-only gallery, object interpretation via Scout lenses | `vlbxjdhicborpgsinepr` | Netlify | Production |
| **nooooowhere-club-rn** | React Native + Python | 3458 (app), 5001 (crew) | Mobile: iOS/Android version + Carrier crew synthesis | `vlbxjdhicborpgsinepr` (same) | Expo | Development |
| **design-tools** | Next.js + Python (Carrier) | 3500 (frontend), 8000 (crew) | Design voting sessions + research synthesis | `separate instance` | Manual | Production-ready |
| **alfredo-studio** | Next.js portfolio | 3456 | Creative coding demos, music tools, p5.js sketches | `separate instance` | Netlify | Active |

## Tier 2: Development & Infrastructure

| Project | Type | Port | Primary Use | Purpose | Status |
|---------|------|------|-------------|---------|--------|
| **design-tools-work** | Next.js (fork) | 3500 | Experimental design ops features | Fork of design-tools for testing Oracle/Meridian crew agents | Experimental |
| **miguel-playground** | Next.js + Storybook | 3100 (app), 6006 (Storybook) | Component testing & feature exploration | Sandbox for testing UI patterns, Storybook documentation | Active |
| **dev-setup** | Bash scripts | — | Environment initialization | Reusable setup scripts and .env templates for all projects | Infrastructure |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                   SHARED SERVICES & INFRASTRUCTURE                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Anthropic API (Claude Haiku 4.5, Opus 4.6)                        │
│  └─ All 4 projects use same API key from ~/.env.global             │
│                                                                     │
│  Ollama Local LLM (port 11434)                                      │
│  └─ design-tools/crew uses llama3.2 for synthesis                  │
│                                                                     │
│  Three Supabase Instances                                           │
│  ├─ MAIN: vlbxjdhicborpgsinepr (nooooowhere-club + mobile)         │
│  ├─ DESIGN-TOOLS: separate instance (Carrier)                      │
│  └─ ALFREDO: separate instance (portfolio)                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────────────────┐    ┌──────────────────────────┐
│   nooooowhere-club       │    │   nooooowhere-club-rn    │
│   Web Gallery (3457)     │    │   Mobile + Crew (3458/5001)
├──────────────────────────┤    ├──────────────────────────┤
│ Next.js 16               │    │ React Native             │
│ Scout lenses             │    │ Scout lenses (same)      │
│ User profiles            │    │ + Carrier crew/          │
│ Gallery uploads          │    │   (CrewAI synthesis)     │
│                          │    │                          │
│ Supabase RLS auth        │    │ Supabase RLS auth        │
│ Claude API calls         │    │ Claude API calls         │
│                          │    │ Python crew on 5001      │
└──────┬───────────────────┘    └──────┬───────────────────┘
       │                               │
       └───────────┬───────────────────┘
                   │
          ┌────────▼────────┐
          │ Shared Supabase │
          │ vlbxjdhicborpgsinepr
          │                 │
          │ tables:         │
          │ ├─ profiles     │
          │ ├─ gallery_items
          │ ├─ lens_runs    │
          │ ├─ gallery_comments
          │ └─ notifications
          └─────────────────┘

┌──────────────────────────┐    ┌──────────────────────────┐
│     design-tools         │    │    alfredo-studio        │
│   Carrier (3500/8000)    │    │   Portfolio (3456)       │
├──────────────────────────┤    ├──────────────────────────┤
│ Next.js 16               │    │ Next.js 16               │
│ Design voting sessions   │    │ Creative coding          │
│ Research synthesis       │    │ Tone.js, p5.js           │
│ CrewAI three-agent       │    │ Interactive demos        │
│ pipeline (crew/)         │    │                          │
│                          │    │ Supabase (separate)      │
│ FastAPI on 8000          │    │ Claude API (optional)    │
│ Ollama (llama3.2)        │    │ Motion animations        │
│ Separate Supabase        │    │                          │
└──────────────────────────┘    └──────────────────────────┘
```

---

## Project Descriptions

### 1. **nooooowhere-club** (Web Gallery)

**What it is:**
An invite-only web gallery where patrons upload images and receive AI-generated cultural/historical readings via **Scout lenses**. Each lens represents a different interpretive angle (art history, social context, materiality, etc.). The app emphasizes contemplation over sharing—three encounters per day, no social feed.

**Tech:**
- Next.js 16 (App Router, Turbopack)
- React 19, Tailwind CSS 4, shadcn/ui
- Supabase Auth (magic link, invite-only registration)
- Claude API (Scout — single-call lens analysis)
- Realtime notifications

**Key Files:**
- `app/api/gallery/lens/` — Lens execution (POST to start, GET to poll)
- `lib/lens/pipeline.ts` — Scout synthesis and database writes
- `components/gallery/gallery-card.tsx` — Wand UI, overlay display

**Database:**
- Shared Supabase: `vlbxjdhicborpgsinepr`
- Tables: `profiles`, `gallery_items`, `lens_runs`, `gallery_comments`, `nownowhere_notifications`

**Deploys To:** Netlify → https://nooooowhere.club

**Port:** 3457

---

### 2. **nooooowhere-club-rn** (Mobile App + Crew)

**What it is:**
React Native iOS/Android version of Nowhere Club with the same gallery interface, plus the **Carrier CrewAI pipeline** (`crew/` directory) for generating curator-voiced readings when the Carrier lens is selected.

**Tech:**
- React Native with Expo
- Same Supabase auth as nooooowhere-club
- Claude API (vision + synthesis)
- CrewAI (6-stage curator voice pipeline)
- FastAPI server on port 5001 (crew/app.py)

**Key Files:**
- `App.tsx` — Root Expo app
- `crew/crew_execute.py` — 6-stage synthesis (detect object → write reading → detect voice markers → generate variations)
- `crew/app.py` — FastAPI server with `/execute-image` endpoint
- `.env.local` — Shares same Supabase and Anthropic keys

**Database:**
- Shared Supabase: `vlbxjdhicborpgsinepr` (same as web gallery)
- Uses same tables, can sync encounters between web and mobile

**Port:**
- 3458 (Expo app, if running locally)
- 5001 (crew API)

**Status:** Development

---

### 3. **design-tools** (Carrier Design Workspace)

**What it is:**
A design synthesis platform for running blind voting sessions on design options, capturing research observations, and generating AI-orchestrated design thinking via three-agent CrewAI pipeline (Product Manager → Research → Designer).

**Tech:**
- Next.js 16 (App Router)
- React 19, Tailwind CSS 4, shadcn/ui
- FastAPI + CrewAI (port 8000, crew/ directory)
- Separate Supabase instance (RLS for session ownership)
- Local Ollama (llama3.2) + Claude Haiku 4.5

**Key Files:**
- `app/tools/design/` — Carrier routes (projects, research, voting)
- `crew/main.py` — FastAPI app and three-agent orchestration
- `crew/agents/` — PM, Research, Designer agent definitions
- `lib/design-store.tsx` — Session context

**Database:**
- **Separate Supabase instance** (not shared with Nowhere Club)
- Tables: `design_sessions`, `explorations`, `votes`, `research_observations`, `research_segments`, etc.

**Port:**
- 3500 (frontend)
- 8000 (crew API)

**Deploys To:** Manual (designed for Vercel, currently manual deployment)

**Status:** Production-ready

---

### 4. **alfredo-studio** (Creative Coding Portfolio)

**What it is:**
A creative coding portfolio showcasing 37+ interactive demos: live music composition (Tone.js + Strudel), ASCII art visualizations, liminal space games, and audio-reactive p5.js sketches. Emphasis on motion, typography, and distinctive design aesthetic.

**Tech:**
- Next.js 16 (static export to Netlify)
- React 19, Tailwind CSS 4, Motion (Framer Motion 12)
- Tone.js (synthesis), p5.js (graphics), Tonal.js (music theory)
- Supabase (separate instance, optional)
- @use-gesture for touch/mouse interactions

**Key Files:**
- `public/demos/` — 37+ interactive HTML/JS demos
- `public/shared/music-theory/harmony.js` — Tonal.js utilities
- `app/chords/page.tsx` — Chord dictionary with playback
- `app/template.tsx` — Motion entrance animations (PageTransition)

**Database:**
- Separate Supabase instance (minimal use, mostly for likes/bookmarks)

**Port:** 3456

**Deploys To:** Netlify → https://alfredo.studio

**Status:** Active

---

## Shared Infrastructure

### Anthropic API Key
All four projects use the same **ANTHROPIC_API_KEY** from `~/.env.global` (stored in `env.global.template`, filled in locally):
```bash
# From ~/.env.global
ANTHROPIC_API_KEY=<your-api-key-from-anthropic-console>
```

**Where it's used:**
- **nooooowhere-club:** Scout lens synthesis (Claude Haiku)
- **nooooowhere-club-rn:** Scout lenses + Carrier crew vision/synthesis (Claude 3.5 Sonnet)
- **design-tools:** Research synthesis (Claude Haiku), code generation (Claude Opus)
- **alfredo-studio:** Optional generative music (Claude API)

### Ollama Local LLM
**design-tools** uses local Ollama (llama3.2) on port 11434:
```bash
OLLAMA_BASE_URL=http://localhost:11434
```

Used for low-cost research observation synthesis. Other projects don't use Ollama.

### Port Assignments
| Port | Service | Project |
|------|---------|---------|
| 3456 | Next.js dev | alfredo-studio |
| 3457 | Next.js dev | nooooowhere-club |
| 3458 | Expo app | nooooowhere-club-rn |
| 3500 | Next.js dev | design-tools |
| 5001 | Crew API (FastAPI) | nooooowhere-club-rn |
| 8000 | Crew API (FastAPI) | design-tools |
| 11434 | Ollama local LLM | All projects (used by design-tools) |
| 54321 | Local Supabase | All projects (when running locally) |

### Supabase Instances

**Three separate databases:**

1. **vlbxjdhicborpgsinepr** (Nowhere Club)
   - Used by: nooooowhere-club (web) + nooooowhere-club-rn (mobile)
   - Shared tables for synchronized experience
   - Auth: Magic link (passwordless)

2. **design-tools** (separate Supabase)
   - Used by: design-tools only
   - RLS for session/research data ownership
   - Research synthesis tables

3. **alfredo-studio** (separate Supabase)
   - Used by: alfredo-studio only
   - Minimal use (likes, bookmarks on demos)

---

## Data Flow & Connections

### Scenario 1: Patron Takes Photo in Nowhere Club
```
Mobile (nooooowhere-club-rn)
  ↓ (photo + Carrier lens selected)
crew/ (port 5001, FastAPI)
  ↓ (6-stage Carrier pipeline)
Claude API (vision + synthesis)
  ↓ (structured reading: observation, contextualization, synthesis)
Supabase (vlbxjdhicborpgsinepr)
  ↓ (stored in gallery_comments.agent_meta)
Web (nooooowhere-club) & Mobile
  ↓ (realtime sync, patron can see same reading on both)
```

### Scenario 2: Design Team Uses Carrier for Voting
```
design-tools frontend (port 3500)
  ↓ (create session, upload design options)
design-tools API (Next.js)
  ↓ (store session metadata)
Supabase (design-tools instance)
  ↓ (sessions, explorations, votes)

Later: Trigger research synthesis
  ↓
crew/ (port 8000, FastAPI)
  ↓ (three-agent pipeline: PM → Research → Designer)
Ollama (llama3.2) + Claude API
  ↓ (synthesis results)
design-tools frontend
  ↓ (display insights with confidence levels)
```

### Scenario 3: Deploy alfredo-studio
```
git push origin main
  ↓
GitHub (default branch = main)
  ↓
Netlify (auto-triggered)
  ↓
npm run build (static export)
  ↓
https://alfredo.studio (live)
```

---

## What's Connected, What's Separate

### **Tight Coupling** (Shared Data)
- **nooooowhere-club ↔ nooooowhere-club-rn**
  - Same Supabase instance (vlbxjdhicborpgsinepr)
  - Same Scout lenses
  - Patron can upload on mobile, view on web (realtime sync via Supabase Realtime)
  - Same invite codes, same profiles
  - Mobile crew/ (port 5001) can run independently or feed back to Supabase

### **Loose Coupling** (Shared Infrastructure Only)
- **All 4 projects share:**
  - Anthropic API key (same service account)
  - Version management (.nvmrc for Node, .python-version for Python)
  - Global git-secrets configuration
  - Global .gitignore patterns

### **Completely Independent** (Separate Data)
- **design-tools** is its own product with separate Supabase
  - Could theoretically feed research insights to Nowhere Club (future integration)
  - Crew pipeline uses same three-agent pattern as nooooowhere-club-rn/crew
- **alfredo-studio** is a portfolio with minimal connections
  - Supabase barely used (optional)
  - No integration with other projects

---

## Development Workflow

### Starting a Session

**Terminal setup (start all projects):**
```bash
# Terminal 1: alfredo-studio (3456)
cd ~/Code/alfredo-studio && npm run dev

# Terminal 2: nooooowhere-club (3457)
cd ~/Code/nooooowhere-club && npm run dev

# Terminal 3: design-tools frontend (3500) + crew (8000)
cd ~/Code/design-tools && npm run dev:all

# Terminal 4: nooooowhere-club-rn crew (5001)
cd ~/Code/nooooowhere-club-rn && source venv313/bin/activate && PYTHONPATH=$(pwd) python crew/app.py

# Terminal 5: Ollama (11434)
ollama serve  # Ensure llama3.2 is loaded
```

### Working on a Feature

1. Create feature branch from main
2. Work in one or more projects
3. Test cross-project integrations if needed (e.g., mobile crew → web gallery)
4. Commit frequently to feature branch
5. Push WIP to origin
6. Open PR before merging

### Deployment Strategy

| Project | Trigger | Destination | Status Check |
|---------|---------|-------------|--------------|
| nooooowhere-club | Manual: `npx netlify deploy --prod` | https://nooooowhere.club | Open site, test Scout |
| alfredo-studio | Manual: `npx netlify deploy --prod` | https://alfredo.studio | Open site, test demos |
| design-tools | Manual (Vercel or Netlify) | TBD | Run crew tests first |
| nooooowhere-club-rn | Expo/EAS Build | iOS/Android testflight | Requires signing certs |

---

## Known Constraints

1. **Python version pinning:**
   - nooooowhere-club-rn/crew requires Python 3.12.x or 3.13.x (CrewAI constraint)
   - design-tools/crew requires Python ≤3.13.x

2. **Supabase instances:**
   - Three separate instances = three separate auth systems
   - Can't query across databases without manual sync

3. **Crew APIs (ports 5001, 8000):**
   - Must be running for Carrier lenses to work
   - Different requirements (different Python versions)
   - Can't run both simultaneously if they conflict (Python version)

4. **Anthropic API:**
   - All projects share one key = shared rate limits
   - Monitor usage if running multiple synthesis jobs

5. **Netlify deployments:**
   - GitHub default branch must be `main` (not a feature branch)
   - Check site settings if deployments fail

---

## Summary Table: What Each Project Does

| Project | Primary Function | Users | Database | API Dependency | Status |
|---------|------------------|-------|----------|-----------------|--------|
| nooooowhere-club | Web gallery + Scout lenses | Invited patrons (web) | Shared (vlbxjdhicborpgsinepr) | Anthropic (lens synthesis) | 🟢 Production |
| nooooowhere-club-rn | Mobile gallery + Carrier crew | Invited patrons (iOS/Android) | Shared (vlbxjdhicborpgsinepr) | Anthropic + local crew (port 5001) | 🟡 Development |
| design-tools | Design voting + research synthesis | Design teams, researchers | Separate (Carrier) | Anthropic + local Ollama | 🟢 Production-ready |
| alfredo-studio | Creative coding portfolio | Public | Separate (minimal) | Anthropic (optional) | 🟢 Active |

---

## Tier 2: Development & Infrastructure Projects

### 5. **design-tools-work** (Experimental Fork)

**What it is:**
Experimental work branch of Carrier (design-tools) for testing new design ops features. Currently exploring Oracle (design violation detection) and Meridian (fix generation) agents in the CrewAI pipeline. Allows rapid iteration without blocking main design-tools.

**Tech:**
- Fork of design-tools (Next.js 16, React 19)
- Experimental CrewAI agents (Oracle, Meridian)
- Shares Supabase schema with design-tools
- Same Node/API versions as design-tools

**Purpose:**
- Test new crew agents before merging to design-tools
- Explore design ops workflows
- Rapid prototyping of AI-driven design features

**Port:** 3500 (same as design-tools, run one at a time)

**Status:** Experimental

**Deploys To:** None (local experimentation only)

---

### 6. **miguel-playground** (Component Testing)

**What it is:**
Sandbox environment for testing new UI components and features before integration into production projects. Includes Storybook for component documentation, visual testing, and isolated development. Named "realmeal-app" internally.

**Tech:**
- Next.js 16 with React 19
- Storybook 10 for component documentation
- Vitest + Playwright for testing
- shadcn/ui + Radix UI for component library
- Tailwind CSS 4

**Purpose:**
- Component-first development and testing
- Storybook stories for design documentation
- Feature exploration before production integration
- Browser testing with Playwright

**Ports:**
- 3100 (Next.js frontend)
- 6006 (Storybook)

**Status:** Active

**Deploys To:** Manual (Vercel possible, currently local only)

---

### 7. **dev-setup** (Infrastructure)

**What it is:**
Reusable environment initialization system for consistent development setup across all machines and projects. Contains global environment variable templates, setup scripts, and best practices for managing secrets securely.

**Tech:**
- Bash scripting
- Environment variable templating
- Git integration (git-secrets)

**Purpose:**
- Centralized environment variable management
- Consistent setup across all developers/machines
- Security: templates in git, secrets in .gitignore
- Single source of truth: ~/.env.global

**Key Files:**
- `setup-env.sh` — Initialization script
- `env.global.template` — Master variable list
- `.env.development` — Development environment template
- `.env.staging` — Staging environment template

**Status:** Infrastructure (foundational)

**Used By:** All Tier 1 and Tier 2 projects

**Setup Command:**
```bash
bash ~/Code/dev-setup/setup-env.sh
```

---

## Project Lifecycle

### Moving from Tier 2 to Tier 1
When an experimental feature or component is production-ready:

1. **design-tools-work → design-tools:** Merge crew agents, sync Supabase schema, update docs
2. **miguel-playground → production:** Move tested component to target project, update Storybook
3. **dev-setup → all projects:** No upgrade needed (infrastructure is shared)

### Adding New Tier 2 Projects
When starting new experimental work or infrastructure:

1. Create folder in ~/Code/
2. Add CLAUDE.md following the Tier 1/2 pattern
3. Update this PROJECTS.md file
4. Ensure .gitignore matches global patterns

