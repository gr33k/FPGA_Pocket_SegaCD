# Task 5V — Quartus documentation directory creation

Task 5V adds the `quartus/` directory with two planning documents only:

- `quartus/README.md`
- `quartus/notes_mixed_language.md`

No actual Quartus project files are added in this task.

## What was created

- A documentation-only `quartus/` directory with planning context for future project creation.
- Repo planning docs updated to point to the new directory and docs.

## Why only documentation files

- Real project file emission and synthesis are intentionally deferred.
- This keeps generated output and tool-coupled decisions explicit for later milestones.
- This prevents accidental assumptions before the mixed-language and runtime dependency chain is confirmed.

## Why real project files remain deferred

- The runtime boundary is still in planning/probe mode.
- No APF synthesis project is active yet.
- No `.qpf/.qsf/.sdc/.tcl/.qip` files are added by design in this milestone.
- APF packaging output remains deferred.

## Why no generated outputs should exist

- No Quartus compilation is executed in this milestone.
- No `.sof/.rbf/.rbf_r` files are generated or tracked.

## Why runtime remains read-only

- `third_party/Genesis_MiSTer` is imported and treated as read-only.
- APF compatibility remains in repository-local wrapper/design paths.
- Sega CD / 32X and memory-controller expansion remain explicitly excluded.

## What Task 5W should do next

Task 5W should create the first non-buildable, human-maintained Quartus skeleton file placeholders, only if clearly separated from synthesis/build execution, with no generated outputs and no gameplay claims.

