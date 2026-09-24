# Where lessons live

Project lessons live in the private repo `~/Code/claude-lessons`, one folder per
project, shared between this machine and the other one. So does chart's
gitignored `CONTEXT.md`.

`tasks/lessons*.md` in a project, and chart's `CONTEXT.md`, are symlinks into that
repo. The Edit and Write tools refuse to write through a symlink. To change one:

1. Run `readlink <file>` and edit the target path.
2. `bin/sync` in the repo runs every day at 22:00 on both machines. To share a
   change sooner, commit and push: `git -C ~/Code/claude-lessons add -A && git -C ~/Code/claude-lessons commit -m "<project>: <lesson title>" && git -C ~/Code/claude-lessons pull --rebase && git -C ~/Code/claude-lessons push`.

Never replace the symlink with a regular file, and never `git add` it in the
project repo. Tracked copies carry `skip-worktree`. If a checkout fails on one,
run `git update-index --no-skip-worktree tasks/<file>`, check out, then restore
the link.

For a project with no folder yet, create `~/Code/claude-lessons/<project>/lessons.md`,
link it with `ln -s`, and add `/tasks/lessons*.md` to the project's `.git/info/exclude`.
