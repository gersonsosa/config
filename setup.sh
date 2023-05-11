#/bin/bash
pushd ~/.dotfiles
if [ -d "~/.config/nvim" ] 
then
    echo "Couln't link neovim config files, ~/.config/nvim already exists" 
else
    ln -s ~/.config/nvim ./nvim
fi

ln -s ~/.tmux.conf .tmux.conf
