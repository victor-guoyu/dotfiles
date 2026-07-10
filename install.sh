#!/bin/bash -eu

source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/zsh/install.sh"

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# install packages
install_homebrew
install_cask "font-code-new-roman-nerd-font"
install_cask "rectangle"
install_cask "hammerspoon"
install_cask "ghostty"
install_package "tmux"
install_package "ripgrep"
install_package "fzf"
install_package "neovim"
install_package "zoxide"

brew_install "fd"
debian_install "fd-find"

# node: required by the typescript LSP server (vtsls/tsserver)
brew_install "node"
debian_install "nodejs"

# symlink dotfiles
# TODO: replace with GNU stow

# ghostty
link_dotfiles "ghostty" "${XDG_CONFIG_HOME}/ghostty"

# zsh
install_zsh

#nvim
link_dotfiles "nvim" "${XDG_CONFIG_HOME}/nvim"

# hammerspoon
link_dotfiles "hammerspoon" "${HOME}/.hammerspoon"

# claude code
mkdir -p "${HOME}/.claude"
link_dotfiles ".claude/settings.json" "${HOME}/.claude/settings.json"

# tmux
link_dotfiles "tmux/tmux.conf" "${HOME}/.tmux.conf"
clone_repo "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
echo "✅ all done!"
