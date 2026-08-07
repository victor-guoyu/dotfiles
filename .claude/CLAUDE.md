# Global instructions

## Commits

Do not add AI attribution to commit messages. No `Co-Authored-By: Claude`
trailer, no "Generated with Claude Code" line, no equivalent in a PR body.
Add one only if I ask for it on a specific commit.

Write the message as I would: imperative subject, sentence case, no trailing
period. Explain *why* in the body when the change is not self-evident.

## Editor

I use Neovim (LazyVim distribution) on macOS, in Ghostty. Config lives in
`~/.config/nvim`; `lua/config/lazy.lua` is where LazyVim extras are imported,
so check there and not just `lazyvim.json`. Assume nvim when I report an
editor problem — don't ask which editor I'm on.

Useful when debugging: plugin source is under `~/.local/share/nvim/lazy/`,
Mason binaries under `~/.local/share/nvim/mason/bin/`, and swap/undo files
under `~/.local/state/nvim/`. Reading the installed plugin source to confirm
actual defaults beats guessing from memory.

I want format-on-save left on. When it misbehaves, find and fix the root
cause; disabling autoformat is triage, not an answer. The same goes for
editor issues generally — I'd rather have the real fix than a workaround
that hides the symptom.
