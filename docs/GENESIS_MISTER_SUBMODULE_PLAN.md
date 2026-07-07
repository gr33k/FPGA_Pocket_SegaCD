# Task 5L: Genesis_MiSTer submodule plan

## Chosen import mechanism

- Import mechanism: git submodule (planned)
- Upstream: `https://github.com/MiSTer-devel/Genesis_MiSTer`
- Planned path: `third_party/Genesis_MiSTer`

## Status for this task

- Completed in Task 5M.

## Task 5M execution result

- Submodule has been added at:
  - `third_party/Genesis_MiSTer`
- Pinned revision:
  - `adc0c42cfb1fa5d484cc8566767f7d68982bc44a`
- This run remains read-only for the runtime boundary.
- APF adapter and scaffold behavior is unchanged by this import.

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

## Why this was done in Task 5M

- Task 5L selected strategy.
- Task 5M performs the actual add and confirms the first runtime source location needed for future compile-oriented dependency passes.
