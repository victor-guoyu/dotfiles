# Global instructions

## Commits

Do not add AI attribution to commit messages. No `Co-Authored-By: Claude`
trailer, no "Generated with Claude Code" line, no equivalent in a PR body.
Add one only if I ask for it on a specific commit.

Use semantic (Conventional Commits) subjects: `type(scope): subject`, where
the scope is optional. Common types are `feat`, `fix`, `refactor`, `perf`,
`docs`, `test`, `build`, `ci`, `chore`. Keep the type and scope lowercase.

Write the subject as I would: imperative, sentence case after the colon, no
trailing period. Explain *why* in the body when the change is not
self-evident.

    fix(nvim): stop checktime from clobbering the buffer while typing

## Editor

I use Neovim (LazyVim distribution) on macOS, in Ghostty. Config lives in
`~/.config/nvim`; `lua/config/lazy.lua` is where LazyVim extras are imported,
so check there and not just `lazyvim.json`. Assume nvim when I report an
editor problem — don't ask which editor I'm on.

My config is symlinked out of `~/dotfiles`, so edit the real path — writing
through the symlink is refused:

    ~/.config/nvim      -> ~/dotfiles/nvim
    ~/.config/ghostty   -> ~/dotfiles/ghostty
    ~/.claude/CLAUDE.md -> ~/dotfiles/.claude/CLAUDE.md

Config changes are therefore commits in `~/dotfiles`.

`~/.config/ghostty/config` is part of the editor surface: it remaps keys
before nvim sees them (e.g. `cmd+s` is sent as `text:\x13`, i.e. `<C-s>`).
When I describe a shortcut by its macOS name, look there to find out what
nvim actually receives — the bug may be in the terminal, not the editor.

Useful when debugging: plugin source is under `~/.local/share/nvim/lazy/`,
Mason binaries under `~/.local/share/nvim/mason/bin/`, and swap/undo files
under `~/.local/state/nvim/`. Reading the installed plugin source to confirm
actual defaults beats guessing from memory.

Two traps when driving nvim under `--headless`:

- `nvim_input` is never pumped, so nothing is typed and the run silently
  "passes". Use `nvim_feedkeys(keys, "x", false)` instead.
- LazyVim keymaps load on `VeryLazy`, which never fires headless, so `<C-s>`
  and friends are unmapped. Keymap behaviour can't be tested this way.

I want format-on-save left on. When it misbehaves, find and fix the root
cause; disabling autoformat is triage, not an answer. The same goes for
editor issues generally — I'd rather have the real fix than a workaround
that hides the symptom.

## Debugging

Before trusting a reproduction, run a control that proves the harness itself
works — a case that must fail and a case that must pass. A test rig that
silently does nothing looks exactly like a fixed bug.

Don't tell me something is reproduced, confirmed, or fixed until it has been
verified that way. "I haven't reproduced this yet" is a useful thing to hear;
a confident wrong diagnosis costs me far more than an honest open question.
