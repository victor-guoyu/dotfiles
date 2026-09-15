# dotfiles

Personal configuration for Neovim, Ghostty, zsh, tmux, Hammerspoon and Claude
Code, plus a script that installs the packages they depend on. macOS and Ubuntu.

## Install

```sh
git clone git@github.com:victor-guoyu/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The clone has to live at `~/dotfiles` — `link_dotfiles` in `utils.sh` builds
symlink targets from that path literally.

## What's here

| Path | Symlinked to | |
| --- | --- | --- |
| `nvim/` | `~/.config/nvim` | LazyVim-based config |
| `ghostty/` | `~/.config/ghostty` | terminal, incl. macOS key remaps |
| `zsh/zshrc`, `zsh/zprofile` | `~/.zshrc`, `~/.zprofile` | oh-my-zsh + plugins |
| `tmux/tmux.conf` | `~/.tmux.conf` | tpm is cloned on install |
| `hammerspoon/` | `~/.hammerspoon` | macOS window management (mac only) |
| `.claude/CLAUDE.md`, `.claude/settings.json` | `~/.claude/` | Claude Code |
| `alacritty/` | — | kept, but not linked by `install.sh` |

## What gets installed

- **Packages** (brew on macOS, apt on Ubuntu): tmux, ripgrep, fzf, neovim,
  zoxide, fd, node — node is needed by the TypeScript LSP server, and is the
  fallback for shells that never sourced `.zshrc`.
- **fnm** — the node version manager, installed from upstream's script on
  Ubuntu since there's no apt package. `.zshrc` runs `fnm env --use-on-cd`, so
  the node version follows `.node-version`, `.nvmrc` or `package.json`
  `engines` as you `cd`. zsh completions are written to `$ZSH_CUSTOM`.
- **Casks** (macOS only): ghostty, hammerspoon, rectangle, and the
  Code New Roman Nerd Font.
- **zsh**: oh-my-zsh, plus autosuggestions, completions,
  history-substring-search and syntax-highlighting.

On Ubuntu the Homebrew and cask steps are skipped rather than failing.

## Notes

- `install.sh` is idempotent — anything already installed or present is
  skipped, so it's safe to re-run after adding a tool.
- Symlinking never overwrites. If a real file or directory already sits at the
  destination, it is left alone and reported; remove it first to relink.
- `install.sh` carries a TODO to replace the hand-rolled symlinking with GNU
  stow.
