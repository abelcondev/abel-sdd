# Contributing to abel-sdd

Thank you for your interest in improving the framework! We follow a lightweight issue and pull request flow.

## How to propose changes

1. **Open an issue** (or use the local SDD flow with `sdd/features/`) describing the problem or improvement.
2. **Fork the repo** or create a feature branch with `scripts/sdd-worktree.sh` if you have permissions.
3. **Make your changes** atomically and with clear documentation.
4. **Open a Pull Request** using the template that appears automatically.
5. **Make sure CI passes** before asking for review.

## How to run `./init.sh` locally

Before sending a PR, verify that the SDD harness is ready:

```bash
./init.sh
```

If everything is OK, you will see:

```text
[OK] SDD harness ready
```

If it fails, fix the reported errors and run it again.

## Commit convention

We use [Conventional Commits](https://www.conventionalcommits.org):

- `docs(<scope>): ...` — documentation changes.
- `chore(<scope>): ...` — maintenance tasks, SDD state, scripts, etc.
- `feat(<scope>): ...` — new functionality.
- `fix(<scope>): ...` — bug fixes.
- `test(<scope>): ...` — tests.
- `refactor(<scope>): ...` — refactor without behavior changes.

For changes related to the local SDD flow we use the `sdd` scope:

```text
chore(sdd): move login [Dev] implementing → review
docs(readme): add CI badge — kit-repo-publico/kit-repo-publico
```

Keep commits atomic and with clear messages in English (the project's primary language).
