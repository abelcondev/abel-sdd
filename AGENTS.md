# AGENTS.md — Map for SDD Agents

This file is the **entry point** for any agent working on a project that uses the SDD.

It is NOT a bible of rules: it is a **map**. Read only what you need when you need it.

---

## 1. Before starting (mandatory)

In every session, the orchestrator agent MUST:

1. **Read `CLAUDE.md`** — enforces the orchestrator role.
2. **Read `sdd/README.md`** — understand the SDD flow.
3. **Check `sdd/features/`** — current state of features and issues.
4. **Run `init.sh` on demand** — when the user asks, before declaring `done`, or when there are changes that justify verifying the environment. Do not run it automatically at the start of every session.

---

## 2. Repository map

| Path/File | Content | When to read |
|---|---|---|
| `CLAUDE.md` | Role enforcer + minimal stack | At the start |
| `AGENTS.md` | This file — map and hard rules | At the start |
| `sdd/README.md` | SDD index | Before any work |
| `sdd/workflow.md` | States, workflow, worktrees, golden rules | Before any work |
| `sdd/architecture.md` | **Template** for stack and architectural decisions | Before implementing |
| `sdd/conventions.md` | **Template** for style, naming, and language | Before writing code |
| `sdd/quality-gates.md` | Definition of Ready/Done, checklist C1–C7 | Before declaring done |
| `sdd/testing.md` | Testing strategy, TDD, fixtures, coverage | Before writing tests |
| `sdd/security.md` | Security, RBAC, PII, compliance | Before implementing features with sensitive data |
| `sdd/delivery.md` | Commits, PRs, merge, and closure | Before delivering |
| `sdd/decisions/` | ADRs (Architecture Decision Records) | When architectural decisions are made |
| `scripts/sdd-worktree.sh` | Worktree manager | When creating a feature |
| `scripts/sdd-move.sh` | Move issues between states | When changing state |
| `.claude/agents/` | Role definitions | Never edit directly |
| `sdd/features/` | Local projects, issues, and specs | Source of truth for the SDD flow |

---

## 3. Hard rules

Non-negotiable rules:

- **Each feature is a Project in `sdd/features/<slug>/`**, with at least one Issue `[Design]` and one Issue `[Dev]`.
- **Each feature lives in its own worktree** from the start: `<main-repo>-<feature-slug>/`.
- **Only one Issue `[Dev]` in `Implementing` or `Review` at a time**.
- **Do not declare `done` without a green `init.sh`**.
- **Do not skip human gates**:
  1. `Spec Needed` → `Designing` (approval of the functional/UI spec).
  2. `Designing` → `Design Ready` (approval of the UI design).
  3. `Spec Ready` → `Implementing` (approval of the technical spec).
  4. `Review` → `Testing` (approval of the review/merge).
- **Issue `[Design]` is considered closed when it reaches `Design Ready`**.
- **Issue `[Dev]` does not advance until Issue `[Design]` is in `Design Ready`**.
- **Tests before implementation (TDD)**. Each `R<n>` generates at least one red test before code.
- **Do not edit production code directly from the orchestrator**. The orchestrator orchestrates; the developer writes code.
- **Every important change is recorded**, not only in chat: in `sdd/features/` (state, Issue/Project description), or in `sdd/decisions/` when it affects architecture.
- **`sdd/` is the source of truth** for state, specs, and tasks. There is no local `feature_list.yaml` nor `specs/` folder.
- **No Issue `[Dev]` with UI moves to `Implementing` without an approved design in `[Design]`**.
- **Leave the repo clean when closing**. No temporary files or orphan branches.

---

## 4. Local SDD workflow

`sdd/` is the source of truth. See `sdd/workflow.md` for full details.

### Entities

```text
sdd/features/<feature-slug>/ = Feature (e.g., "login-y-dashboard-layout")
  ├── README.md = context, scope, and out-of-scope of the feature
  ├── design/
  │   ├── spec-needed/   = issues with functional/UI spec pending
  │   ├── designing/     = issues iterating UI design
  │   └── design-ready/  = approved issues
  └── dev/
      ├── backlog/       = issues blocked by [Design]
      ├── spec-needed/   = issues with technical spec pending
      ├── spec-ready/    = issues with complete technical spec (awaiting approval)
      ├── implementing/  = issues in implementation
      ├── blocked/       = issues paused due to external blocker
      ├── review/        = issues in review
      ├── rejected/      = issues rejected in review (rework)
      ├── testing/       = merged issues, in final validation
      ├── done/          = completed issues
      └── cancelled/     = discarded issues
```

### States

**Issue `[Design]`**:

```text
spec-needed → designing → design-ready
```

| State | Meaning |
|---|---|
| `spec-needed` | Issue created. Functional + UI/UX spec still needs to be written. |
| `designing` | UI design is iterated in the project's design tool. |
| `design-ready` | UI design approved. Issue `[Dev]` may advance. |

**Issue `[Dev]`**:

```text
backlog → spec-needed → spec-ready → implementing → review → testing → done
                    ↓         ↓           ↓              ↑
                blocked   blocked     blocked      rejected
                                    cancelled
```

| State | Meaning |
|---|---|
| `backlog` | Issue created, blocked by `[Design]`. |
| `spec-needed` | Technical spec + implementation plan + Test Plan still need to be written. |
| `spec-ready` | Technical spec complete. Awaiting human approval. |
| `implementing` | Developer working in the worktree. |
| `blocked` | Issue paused due to external blocker or pending decision. |
| `review` | Code ready. Auditor verifying. |
| `rejected` | Auditor rejected. Rework required. |
| `testing` | Merged. Final validation. |
| `done` | Feature completed and verified. |
| `cancelled` | Issue discarded. |

### Responsibilities by phase

| Phase | Responsible | Action |
|---|---|---|
| Idea | Human/Orchestrator | Create feature worktree with `./scripts/sdd-worktree.sh create <feature-slug>`. |
| Product Discovery | product_manager | Interview the human with `AskUserQuestion` and write product spec + BDD in Issue `[Product]`. |
| Product review | Human | Approve product spec. Orchestrator moves file to `product/product-ready/`. |
| Spec Design | designer | Interview the human with `AskUserQuestion` and write functional + UI/UX spec in Issue `[Design]`. |
| Spec review | Human | Approve functional/UI spec. Orchestrator moves file to `design/designing/` with `./scripts/sdd-move.sh`. |
| UI Design | Human/Assisted agent | Iterate in the project's design tool. Update assets in Issue `[Design]`. |
| Design review | Human | Approve design. Orchestrator moves file to `design/design-ready/`. |
| Spec Dev | tech_specifier | Write technical spec + Test Plan + Impact Analysis in Issue `[Dev]` file. Orchestrator moves to `dev/spec-needed/` or `dev/spec-ready/`. |
| Spec technical review | Human | Approve technical spec. Orchestrator moves to `dev/implementing/`. |
| Implementation | developer | Run TDD: write red tests, minimum implementation, refactor. Write code in the project. When finished, orchestrator moves to `dev/review/`. |
| Review | auditor | Audit against `sdd/quality-gates.md` C1–C7 and `sdd/security.md`. |
| Closure | Orchestrator | Merge the worktree into `main`, remove worktree, move file to `dev/done/`. |

---

## 5. Session close lifecycle

Before declaring a session closed:

1. Run `init.sh`. It must print `[OK] SDD harness ready`.
2. If an Issue `[Dev]` was finished, make sure its file is in `dev/done/`.
3. If an Issue `[Design]` was closed, make sure its file is in `design/design-ready/`.
4. Update `sdd/README.md` and `sdd/workflow.md` with the current state of projects.
5. Make sure there are no suspicious untracked files.

---

## 6. If blocked

If an agent gets blocked:

1. Re-read the relevant docs.
2. Move the Issue to `dev/blocked/` with `./scripts/sdd-move.sh`.
3. Document the blocker as a comment in the corresponding Issue in `sdd/features/` (`[Design]` or `[Dev]`).
4. Stop the session. Do not invent workarounds.
