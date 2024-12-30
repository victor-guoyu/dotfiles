#!/bin/bash -eu

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# symlink dotfiles
configs=(
  "hammerspoon"
  "alacritty"
)
for config in ${configs[@]}; do
  dest=${HOME}/.${config}
  if [ -L ${dest} ]; then
    echo "${dest} symlink already exists, skipping"
  elif [ -f ${dest} ]; then
    echo "${dest} is a file, skipping"
  elif [ -d ${dest} ]; then
    echo "${dest} is a dir, skipping"
  else
    ln -s ~/dotfiles/${config} ${dest}
  fi
done

ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
