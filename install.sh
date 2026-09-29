#!/bin/bash -eu

source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/zsh/install.sh"

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# symlink dotfiles
# TODO: replace with GNU stow
#
# First, before anything that needs root or the network: the links are the
# config itself, and -e means any later failure would otherwise leave nvim
# starting with no config at all. (zsh's links are made in install_zsh.)

# ghostty
link_dotfiles "ghostty" "${XDG_CONFIG_HOME}/ghostty"

#nvim
link_dotfiles "nvim" "${XDG_CONFIG_HOME}/nvim"

# hammerspoon
link_dotfiles "hammerspoon" "${HOME}/.hammerspoon"

# claude code
mkdir -p "${HOME}/.claude"
link_dotfiles ".claude/settings.json" "${HOME}/.claude/settings.json"
link_dotfiles ".claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"

# tmux
link_dotfiles "tmux/tmux.conf" "${HOME}/.tmux.conf"

# install packages
install_homebrew
install_cask "font-code-new-roman-nerd-font"
install_cask "rectangle"
install_cask "hammerspoon"
install_cask "ghostty"
install_cask "hiddenbar"

# What a bare Ubuntu image lacks and the rest of this script and LazyVim
# assume: git and curl for the installers below, unzip for Mason, and a C
# compiler for the treesitter parsers. macOS has all four.
debian_install "git"
debian_install "curl"
debian_install "unzip"
debian_install "build-essential"

install_package "tmux"
install_package "ripgrep"
install_fzf
install_package "zoxide"
install_neovim

brew_install "fd"
debian_install "fd-find"

# node: required by the typescript LSP server (vtsls/tsserver). Kept as the
# non-interactive fallback too — fnm's node is only on PATH in shells that
# sourced .zshrc.
brew_install "node"
debian_install "nodejs"
# Ubuntu splits npm out of nodejs (brew's node bundles it), and Mason installs
# pyright and vtsls with npm -- without it both fail with "Could not find
# executable npm".
debian_install "npm"

# fnm: node version manager (replaces nvm)
install_fnm

# buf: protobuf toolchain. Backs nvim's proto support — buf_ls is `buf lsp
# serve` from this same binary, and conform formats .proto with `buf format`.
install_buf

# zsh
install_zsh

clone_repo "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"

echo "✅ all done!"
