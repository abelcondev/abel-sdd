# abel-sdd

[![CI](https://github.com/abelcondev/abel-sdd/actions/workflows/ci.yml/badge.svg)](https://github.com/abelcondev/abel-sdd/actions/workflows/ci.yml)

> **Stack-agnostic workflow framework** for designing, building, and delivering software with specs, human gates, worktrees, and TDD.

## What is it?

**abel-sdd** is a Markdown + Git based workflow for governing feature development without depending on an external ticket system.

- **Markdown** as the source of truth for specs and issues.
- **Git** as the history of states.
- **Worktrees** as isolation per feature.
- **Human gates** as mandatory checkpoints.
- **TDD** as a way to build with tests.

It does not impose language, framework, database, package manager, or design tool. Each project completes its own decisions in `sdd/architecture.md` and `sdd/conventions.md`.

## Installation

Download the framework and run the installer:

```bash
git clone <repo-url> /tmp/abel-sdd
cd /tmp/abel-sdd
./install.sh /path/to/your-project
```

Or, if you already have the repo locally:

```bash
cd /path/to/abel-sdd
./install.sh /path/to/your-project
```

> The installer copies `sdd/`, `scripts/`, `.claude/agents/`, `AGENTS.md`, `CLAUDE.md`, and `init.sh` to the destination project without touching its source code.

Then, in the destination project:

1. Fill out `sdd/architecture.md` with the project stack.
2. Fill out `sdd/conventions.md` with style, naming, and language.
3. Optional: create `scripts/project-checks.sh` to add test/lint/build validations.
4. Run `./init.sh` to verify the harness.

## One-command installer

Install `sdd-cli` once and run it from any local Git repository:

```bash
curl -fsSL https://raw.githubusercontent.com/abelcondev/abel-sdd/main/sdd-cli > ~/.local/bin/sdd
chmod +x ~/.local/bin/sdd
```

Make sure `~/.local/bin` is in your `PATH`.

Then, from any project:

```bash
cd /path/to/your-project
sdd init     # Install the latest SDD
sdd update   # Update an existing SDD
sdd status   # Run ./init.sh
sdd worktree create login-y-dashboard-layout
```

## Quick start

### Create a feature

```bash
./scripts/sdd-worktree.sh create login-y-dashboard-layout
```

This creates:

- Branch `feature/login-y-dashboard-layout`.
- Worktree `my-project-login-y-dashboard-layout/` next to the main repo.
- Empty structure in `sdd/projects/login-y-dashboard-layout/`.

### Move issues between states

```bash
./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review
```

This runs `git mv` and generates the state commit:

```text
chore(sdd): login [Design] spec-needed → designing
```

### Verify the harness

```bash
./init.sh
```

It must print `[OK] SDD harness ready` before declaring a session closed.

## Structure

```text
.
├── AGENTS.md              # Agent map
├── CLAUDE.md              # Orchestrator prompt
├── init.sh                # Verifies the SDD harness
├── install.sh             # Installs the framework into a destination project
├── LICENSE
├── CONTRIBUTING.md        # Contributor guide
├── CHANGELOG.md           # Change history
├── .github/
│   ├── workflows/ci.yml   # CI with GitHub Actions
│   └── PULL_REQUEST_TEMPLATE.md
├── sdd/
│   ├── README.md          # Index
│   ├── workflow.md        # States and flow
│   ├── architecture.md    # Stack template
│   ├── conventions.md     # Conventions template
│   ├── quality-gates.md   # C1–C7
│   ├── testing.md         # TDD and testing
│   ├── security.md        # Security
│   ├── delivery.md        # Commits, PRs, merge
│   ├── troubleshooting.md # Common issues guide
│   ├── decisions/         # Project ADRs
│   ├── templates/         # Issue templates
│   └── projects/          # Active features
├── scripts/
│   ├── sdd-worktree.sh    # Creates/removes worktrees
│   └── sdd-move.sh        # Moves issues between states
└── .claude/agents/        # Role definitions
```

## Roles

| Role | What it does | What it does NOT do |
|---|---|---|
| **Orchestrator** | Orchestrates the flow, moves states, closes sessions | Never edits production code |
| **Specifier** | Writes functional and technical specs; interviews the human | Does not implement code |
| **Developer** | Writes code and tests following TDD | Does not skip gates or approve their own work |
| **Auditor** | Audits code against quality gates C1–C7 | Does not implement on the same feature they review |
| **Human** | Approves the 4 gates | Does not write code or specs (unless they want to) |

## Flow

Each feature goes through three phases with human approval gates between them:

```text
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Product  │ --> │  Design  │ --> │   Dev    │
│ discovery│     │designing │     │implementing
│product-  │     │design-   │     │review ->  
│  ready   │     │  ready   │     │  testing  │
└──────────┘     └──────────┘     └──────────┘
     │                 │                 │
     └─────────────────┴─────────────────┘
          Mandatory human gate
```

1. **Product**: define the problem, scope, and out-of-scope.
2. **Design**: iterate the functional/UI spec until approved.
3. **Dev**: write the technical spec, implement with TDD, and audit.

See `sdd/workflow.md` for the full detail of states and transitions.

## License

MIT
