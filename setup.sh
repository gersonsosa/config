#!/bin/bash
if [ -d "~/.config/nvim" ] 
then
  echo "Couln't link neovim config files, ~/.config/nvim already exists" 
else
  pushd ~/.config/
  ln -s ~/.dotfiles/nvim/
fi

ln -s .tmux.conf ~/
