#!/bin/bash -eu

source "$(dirname "$0")/utils.sh"

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# symlink dotfiles
# TODO: replace with GNU stow

# ghostty
link_dotfiles "ghostty" "${XDG_CONFIG_HOME}/ghostty"

# hammerspoon
link_dotfiles "hammerspoon" "${HOME}/.hammerspoon"

# tmux
link_dotfiles "tmux/tmux.conf" "${HOME}/.tmux.config"
