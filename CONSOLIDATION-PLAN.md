# Monorepo Consolidation Plan

Merging nooooowhere-club (web) + nooooowhere-club-rn (mobile) into single monorepo.

## Why
- Share Scout lenses logic (same interpretation engine)
- Shared Supabase DB (same auth, same gallery)
- Coordinated releases (web + mobile in sync)
- Reduce duplication
- Simpler dependency management

## Structure (Target)

```
nooooowhere/                    (new monorepo)
├── web/                        (nooooowhere-club code)
│   ├── app/
│   ├── components/
│   ├── lib/lens/
│   ├── package.json
│   └── .nvmrc
├── mobile/                     (nooooowhere-club-rn code)
│   ├── app/
│   ├── components/
│   ├── lib/lens/              (symlink or shared/)
│   ├── App.tsx
│   ├── package.json
│   └── .nvmrc
├── shared/                     (new: shared code)
│   ├── lens/
│   │   ├── scout-synthesis.ts (extracted from both)
│   │   ├── types.ts
│   │   └── utils.ts
│   ├── lib/
│   │   └── supabase.ts
│   └── package.json
├── crew/                       (nooooowhere-club-rn/crew, moved up)
│   ├── main.py
│   ├── crew_venv/
│   └── requirements.txt
├── .env.template
├── .git/                       (merged history from both repos)
├── CLAUDE.md                   (updated for monorepo)
├── PROJECTS.md                 (updated)
├── package.json                (root, manages web + mobile + shared)
└── README.md                   (explains structure)
```

## Steps (High Level)

### Phase 1: Prepare
- [ ] Create new `nooooowhere` repo on GitHub
- [ ] Decide: keep old repos or delete after migration?
- [ ] Backup both repos locally
- [ ] Document any custom CI/CD for both (Netlify for web, Expo for mobile)

### Phase 2: Merge History
- [ ] Create local `nooooowhere` directory
- [ ] Initialize with nooooowhere-club history
- [ ] Merge nooooowhere-club-rn history (preserving commits)
- [ ] Move files into web/ and mobile/ subdirectories
- [ ] Rewrite paths in commits (git filter-repo)

### Phase 3: Extract Shared Code
- [ ] Identify duplicate code (lens logic, types, supabase utils)
- [ ] Create shared/ directory
- [ ] Move shared code there
- [ ] Update imports in web/ and mobile/
- [ ] Test both still work

### Phase 4: Update Build Config
- [ ] Root package.json with workspaces (if using npm)
- [ ] Update CI/CD (web deploys to Netlify, mobile to Expo)
- [ ] Ensure .env vars work for both
- [ ] Update CLAUDE.md for monorepo structure

### Phase 5: Deploy & Cutover
- [ ] Push to GitHub
- [ ] Update GitHub Actions/CI
- [ ] Deploy web (Netlify)
- [ ] Build mobile (Expo)
- [ ] Verify both work from monorepo
- [ ] Delete old repos (or archive)
- [ ] Update PROJECTS.md

## Tools Needed
- `git filter-repo` (rewrite paths in history)
- npm workspaces (manage dependencies)
- Netlify (web deploy, already configured)
- Expo (mobile, already configured)

## Risks
- Git history complexity (both repos have years of commits)
- Monorepo size (will be larger)
- CI/CD needs to be reconfigured
- Mobile crew/ is Python, web is Node (different venvs)

## Alternatives If Consolidation Is Too Complex
- Keep separate repos, just share a `shared-lens-logic` package
- Move shared code to npm package, both repos depend on it
- Leave as-is (separate repos work fine)

## Timeline
- Phase 1-2: 1-2 hours (history merging is delicate)
- Phase 3-4: 2-3 hours (testing, imports)
- Phase 5: 1 hour (deploy & verify)
- **Total: ~4-6 hours of focused work**

---

**Next Session:** Start with Phase 1 (prepare) in fresh context.
