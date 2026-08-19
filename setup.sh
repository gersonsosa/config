#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -s "$src" "$dst"
  echo "Linked $src -> $dst"
}

setup() {
  if [ -d "$DOTFILES" ]; then
    echo "Dotfiles already cloned, pulling latest"
    git -C "$DOTFILES" pull
  else
    git clone https://github.com/gersonsosa/config.git "$DOTFILES"
  fi
}

link_configs() {
  mkdir -p "$HOME/.config"

  link "$DOTFILES/nvim" "$HOME/.config/nvim"

  case "$(uname -s)" in
    Darwin)
      NU_CONFIG="$HOME/Library/Application Support/nushell"
      ;;
    Linux)
      NU_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nushell"
      ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac
  mkdir -p "$(dirname "$NU_CONFIG")"
  link "$DOTFILES/nushell" "$NU_CONFIG"

  git clone git@github.com:nushell/nu_scripts.git "$HOME/.config/nu_scripts"
}

setup_langs() {
  curl -fL https://github.com/VirtusLab/coursier-m1/releases/latest/download/cs-aarch64-apple-darwin.gz \
    | gzip -d > cs && chmod +x cs
}

setup
link_configs
