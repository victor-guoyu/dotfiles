#!/bin/bash -eu

source "$(dirname "$0")/utils.sh"

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}


# symlink dotfiles

# alacritty
link_dotfiles "alacritty" "${XDG_CONFIG_HOME}/alacritty"

# hammerspoon
link_dotfiles "hammerspoon" "${HOME}/.hammerspoon"

# tmux
link_dotfiles "tmux/tmux.conf" "${HOME}/.tmux.config"
