export EDITOR=nvim
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_CTYPE='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/bin"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PROFILE_SOURCED=1

# bashrc is bash-only; /bin/sh on Linux may source this file and is not bash.
if [ -n "$BASH_VERSION" ] && [ -z "$BASHRC_SOURCED" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
