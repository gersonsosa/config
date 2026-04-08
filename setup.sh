#!/bin/bash

# clone config repo
# link bash
# install tools
# install setup_langs
setup() {
  git clone https://github.com/gersondev/config ~/.dotfiles
  ln -s ~/.dotfiles/.bashrc ~/.bashrc
  ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
  # TODO: setup nu
}

tools() {
  if [ -d "~/.config/nvim" ]
  then
    echo "Couldn't link neovim config files, ~/.config/nvim already exists"
  else
    pushd ~/.config/
    ln -s ~/.dotfiles/nvim/
  fi

  ln -s .tmux.conf ~/
}

setup_langs() {
  # setup coursier bloop etc.
  curl -fL https://github.com/VirtusLab/coursier-m1/releases/latest/download/cs-aarch64-apple-darwin.gz | gzip -d > cs
}

setup()
