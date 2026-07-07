# Task 5L: Genesis_MiSTer submodule plan

## Chosen import mechanism

- Import mechanism: git submodule (planned)
- Upstream: `https://github.com/MiSTer-devel/Genesis_MiSTer`
- Planned path: `third_party/Genesis_MiSTer`

## Status for this task

- Do **NOT** run these commands in Task 5L.
- This task documents the command flow only; actual submodule addition is deferred to Task 5M.

## Future commands (documentation only)

```bash
git submodule add https://github.com/MiSTer-devel/Genesis_MiSTer.git third_party/Genesis_MiSTer
git submodule update --init --recursive
git status
git add .gitmodules third_party/Genesis_MiSTer
git commit -m "Task 5M: add Genesis_MiSTer as pinned submodule"
```

## Clone/update notes

If cloning a repo that already includes this submodule, future onboarding should use:

```bash
git clone --recurse-submodules <repo-url>
```

or, after clone:

```bash
git submodule update --init --recursive
```

## Why this is deferred to Task 5M

- Task 5L is strategy definition only.
- Submodule operations should occur in a separate step when manifest updates and dependency scans can immediately validate the newly present runtime files.
