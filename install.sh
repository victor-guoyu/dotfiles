#!/bin/bash -eu

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# symlink dotfiles

link_dotfiles() {
  local src="$1"
  local destination="$2"

  if [ -L "${destination}" ]; then
    echo "${destination} symlink already exists, skipping"
  elif [ -f ${destination} ]; then
    echo "${destination} is a file, skipping"
  elif [ -d ${destination} ]; then
    echo "${destination} is a dir, skipping"
  else
    echo "symlinking ${src}"
    ln -s ~/dotfiles/"${src}" "${destination}"
  fi
}

# alacritty
link_dotfiles "alacritty" "${XDG_CONFIG_HOME}/alacritty"

# hammerspoon
link_dotfiles "hammerspoon" "${HOME}/.hammerspoon"

# tmux
link_dotfiles "tmux/tmux.conf" "${HOME}/.tmux.config"
