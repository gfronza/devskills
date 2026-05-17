Author a new devskills command.

When invoked, help the user create a command file that fits the devskills conventions, then place it in both command directories.

## devskills command format

A command is a single Markdown file — no YAML frontmatter. Structure:

- **Line 1** — one imperative sentence stating what the command does. This is what the agent sees when deciding to load it, so make it specific.
- **Blank line, then context** — a short "When invoked, ..." paragraph framing the task.
- **`## Process` / `## Rules` / `## Output` sections** — concrete, ordered instructions. Keep prose tight; fragments are fine.

No companion files. If a command needs more than one file, it is doing too much — split it into separate commands.

## Process

1. Gather the requirement: what task the command automates, and when the user would invoke it.
2. Draft the command file following the format above. Keep it focused — one job per command.
3. Write it to BOTH `claude/commands/<name>.md` and `opencode/commands/<name>.md`; the two must stay byte-identical.
4. Add a row to the README "Included Skills" table and bump the file count in the directory tree.
5. Show the draft to the user for review before finalizing.

## Rules

- The filename is the command name: `/<name>` invokes `<name>.md`.
- Match the voice of the existing commands — imperative, no filler.
- If adapting from an external source, add the upstream repo to the README "References" section instead of a `Source:` line in the command.

## Output

The new command file (both copies) and the README updates, shown for review.
